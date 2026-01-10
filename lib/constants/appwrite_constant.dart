class AppwriteEnvironment {
  static const String appwriteProjectId = '6945598a0033809079ca';
  static const String appwriteProjectName = 'twitterclone';
  static const String appwritePublicEndpoint =
      'https://fra.cloud.appwrite.io/v1';

  static const String databaseId = '69455e8700393822a252';
  static const String tableId = 'user_table';
  static const String tweetCollection = 'tweet_collection';
  static const String imageBucketId ='6962bcb7001eac99e4fd';

  static String imageUrl(String imageId) => '$appwritePublicEndpoint/storage/buckets/$imageBucketId/files/$imageId/view/project=$appwriteProjectId&mode=admin';
}
