class EvaluationData {
  int countDRT = 0;
  String totalElapsedTime = "";
  List<int> drtTimes = [];
  String meanDRT = "";

  int getCountDRT() {
    return countDRT;
  }

  String getTotalElapsedTime() {
    return totalElapsedTime;
  }

  List<int> getDrtTimes() {
    return drtTimes;
  }

  String getMeanDRT() {
    return meanDRT;
  }

  void setTotalElapsedTime(String totalElapsedTime) {
    this.totalElapsedTime = totalElapsedTime;
  }

  void setCountDRT(int countDRT) {
    this.countDRT = countDRT;
  }

  void setDrtTimes(List<int> drtTimes) {
    this.drtTimes = drtTimes;
  }

  void setMeanDRT(String meanDRT) {
    this.meanDRT = meanDRT;
  }
}
