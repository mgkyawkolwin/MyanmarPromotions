class CommonAppData
{
  static bool isAuth = false;
  static String userID = '';
  static String userName = '';
  static String displayName = '';
  static String image = '';
  static String phone = '';
  static String email = '';
  static String address = '';

  static void ClearAll()
  {
    isAuth = false;
    userID = '';
    userName = '';
    displayName = '';
    image = '';
    phone = '';
    email = '';
    address = '';
  }

}