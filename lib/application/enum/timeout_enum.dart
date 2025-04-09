enum TimeOutEnum {
  scanningTimeOut(60),
  pairingTimeOut(30),
  connectSuccessfullyDelay(3);

  final int seconds;
  const TimeOutEnum(this.seconds);
}
