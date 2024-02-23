class EvaluationData {
  int countDRT = 0;
  String totalElapsedTime = "";
  List<int> drtTimes = [];
  String meanDRT = "";
  Map<int, String> exceedsBoxFrame = {};

  double maxIntensityError = 0.00;

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

  Map<int, String> getExceedsBoxFrame() {
    return exceedsBoxFrame;
  }

  double getMaxIntensityError() {
    return maxIntensityError;
  }

  void setMaxIntensityError(double intensityError) {
    maxIntensityError = intensityError;
  }

  void setExceedsBoxFrame(int errorNumber, String time) {
    exceedsBoxFrame[errorNumber] = time;
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
