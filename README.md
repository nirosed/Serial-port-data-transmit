# Serial-port-data-transmit
Serial port data transmit implemented by verilog

transmit a data via serial port

1. DetectHign2Low OK
2. DetectLow2High按照DetectHign2Low修改获得，行不行不知道？但至少tb运行OK
3. BpsClkGen：生成baudrate使能时钟。
4. UartTx发送一个字节到串口。使能端控制发送
5. DataSend将一个7字节数发送，在最前面加入FF作为数据头。使能端控制发送
