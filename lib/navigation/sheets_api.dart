import 'package:gsheets/gsheets.dart';

class UserFields {
  static final String id = 'id';
  static final String name = 'name';
  static final String email = 'email';
  static final String isBeginner = 'isBeginner';

  static List<String> getFields() => [id, name, email, isBeginner];
}

class UserSheetsApi {
  static const _credentials = r'''
{
    "type": "service_account",
    "project_id": "proflow-382807",
    "private_key_id": "31ef71da132a867b1399ea4707bbd1f95d3932f7",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCuwf7rOXDw0JRm\nGpGPh4gnQ4nZqmLZmgdZb2PReYOBe33UvFo7/xa57/P59GCfb6WRdk3tWtglnaFh\nrO1ItXstTw7U/D5DDz1Yt+htluQ1tQDWu/zE8CYCId6y3F81Nk25Cr2kDRDVD3gc\nF26l29RPP4TGe+alxDMur7MOlfR4jgPdg7xNon6/r0FYJGPeKAp9yh7b8tGjhzp5\nC6A6qk6HomyRfQH4+KgDQNU86aI04WAOgl2IX7VqcEiChDn1yR9DgHULOYaNBy9T\nMqYwI8PrJyDkYZYPlkEddc4fFa20CKl9yIFeeNhLm9R2cWweJCR7bMI2eyc4KjI5\n+2OwZbLbAgMBAAECggEABz5FLuy05gD51aLjm5uregJ48+D1sz0zcXKGJEgxZNbV\n0qZykFVfVMTsS3+PLayL+T56YQxzNFlB4hwvwuQQFJhX7ginxVHGt3xP5ug/0eC3\nBdoe0kQoic1rlJBBEKHikM6Fflzdm2cbvFZVoLbpfYC4I8iTjmqruxNPNvCM2cjq\nCZskgZZZg4LHkhHfrV0YZxZP/jXgmXUiG2w77cNfS4wQAqFoc/cbfwZMnCkbnCss\nBjG4spavUsW0BM6OCdkDaK1rDLKBHmQBT9paYib4b9v+Hp08pfLvAUZI1I4CpZjl\nmHLk02FdCtLTaIX9+IbJruN22fHDt/7XpWV3Gy8i0QKBgQD0v8/8UmU2YF8mQuEm\njvfe3VOXefZeCnZYvb04zdUAqIbiVENisrhGsJ/LNjOvvrpLYy61GAenNIJ34bqd\nK6vFGeZr3Aemsw80DNPN3XlHVS593R9efpgd03ekTtcdrst1LFTvry4HDc9ZDszV\nLOhtd/AEZh1+hN+N/rGmYoPImQKBgQC2yoeqDD+ZDxVCDT3MEVJ/XJotXHgmYURR\nS+B7R5QEvseD9CViEw4iu1qsPaaLRNoQjQED++ptAlfcJAQvNTQCcykH4q3CvV6U\nR2A8hS3e/kqBi7OhqxtDiFL5QtxnR+m/jD7UOiDWsKH0sj864RPMV+qnwOodhghb\nxC8FVxh7kwKBgQCw2SS1IuhlaS93mx3LWcT7cZukOYlunEq1hqyCriA6MIv+YHqs\nh40l7xwXnxur4roEHS+zxSBKjmOzshTA2rxsWHGqADw7FOloZ9hnyZ+HjqJgafXv\ntrO94X5y6FEB7rqu+RCKfF9a03y+0jXp12A/MUnqM8seD27l0GKXYlntCQKBgQCs\nLbIEd20gm5iGkzp2koqG9Y800zlJza0wdqyI8y92GM6OeNcNvq0+AgSy4Y+S99QA\naxFd01lKPT7NWg+m+BJ5jEhF6TuLiB0ixujbmQdQWW+M/y7BRg90WWDu8g/yKUcA\n6vXzqp1sHQ0xFQWCTKj9foLGaW0dSjdtWSqBeTzSiQKBgQDwq/n/yEQUUqOpVXzT\nofmd6cWO4kwvKwPyFBXTjBSPNswGHLQwyjjo9Q0r2nGK4B7C7im38f4GZ7WB9Dyg\navi28EyrjCgDzzXeWqmlBvc2D/GSMmj+CNMrYZbgsSkk2uFsqlAFTfo+7/AIS6P/\nUPd3E4Ae/+7a55nrGQvE5X5vPg==\n-----END PRIVATE KEY-----\n",
    "client_email": "proflow@proflow-382807.iam.gserviceaccount.com",
    "client_id": "101790528721992621547",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/proflow%40proflow-382807.iam.gserviceaccount.com"
}
''';
  static final _spreadsheetId = '17k4hJmGHGFnna7zZyjoclYT98an4e2UPQhbb0cQli5E';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _userSheet;

  static Future init() async {
    try {
      final _spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _userSheet = await _getWorkSheet(_spreadsheet, title: 'Sheet1');
      //gets the values
      final firstRow = UserFields.getFields();
      _userSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print(e);
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    return spreadsheet.worksheetByTitle(title)!;
  }
}
