import 'dart:io';
import 'dart:typed_data';

void main(List<String> args) {
  RawDatagramSocket.bind(InternetAddress.anyIPv4, 4444).then((RawDatagramSocket socket){
    print('Datagram socket ready to receive');
    print('${socket.address.address}:${socket.port}');
    socket.listen((RawSocketEvent e){
      Datagram d = socket.receive();
      if (d == null) return;
      print(d.data);
      ByteBuffer buffer = Int8List.fromList(d.data).buffer;
      ByteData byteData = ByteData.view(buffer);
      double result = byteData.getFloat64(0, Endian.little);
      print('Datagram from ${d.address.address}:${d.port}: ${result}');
      result += .1;
      byteData.setFloat64(0,result, Endian.little);
      buffer = byteData.buffer;
      List<int> finalData = buffer.asInt8List().toList();
      socket.send(finalData, d.address, d.port);
    });
  });
}

