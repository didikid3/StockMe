class UserNotification{
  bool notifications = true;

  void setState(bool notifications) {
    this.notifications = notifications;
  }

  bool getState(){
    return notifications;
  }

}