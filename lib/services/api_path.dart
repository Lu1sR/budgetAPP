class ApiPath {
  static String transactions(String uid) => 'users/$uid/transactions';
  static String results() => 'users';
  static String transaction(String uid, String transactionID) =>
      'users/$uid/transactions/$transactionID';
}
