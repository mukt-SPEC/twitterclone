enum TweetType {
  text('text'),
  image('image');

  final String type;
  const TweetType(this.type);
}

enum NotificationType {
  like('like'),
  reply('reply'),
  follow('follow'),
  retweet('retweet');

  final String type;
  const NotificationType(this.type);
}

extension ConvertNotification on String {
  NotificationType toNotifcationTypeEnum() {
    switch (this) {
      case 'follow':
        return NotificationType.follow;
      case ' reply':
        return NotificationType.reply;

      case 'retweet':
        return NotificationType.retweet;

      default:
        return NotificationType.retweet;
    }
  }
}
