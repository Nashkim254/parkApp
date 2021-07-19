import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gmap/models/user.dart';
import 'package:gmap/screens/profilescreen.dart';

class SearchPage extends StatefulWidget {
  static const id = 'search';
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  Future<QuerySnapshot> userDocs;

  buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          }),
      title: Form(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Search for a vehicle...',
            prefixIcon: IconTheme(
              data: IconThemeData(color: Colors.grey[700]),
              child: Icon(Icons.search),
            ),
          ),
          onFieldSubmitted: submit,
          textCapitalization: TextCapitalization.characters,
        ),
      ),
    );
  }

  ListView buildSearchResults(List<DocumentSnapshot> docs) {
    List<UserSearchItem> userSearchItems = [];

    docs.forEach((DocumentSnapshot doc) {
      User user = User.fromDocument(doc);
      UserSearchItem searchItem = UserSearchItem(user);
      userSearchItems.add(searchItem);
    });

    return ListView(
      children: userSearchItems,
    );
  }

  void submit(String searchValue) async {
    Future<QuerySnapshot> users = FirebaseFirestore.instance
        .collection("vehicles")
        .where('vno', isGreaterThanOrEqualTo: searchValue)
        .get();

    setState(() {
      userDocs = users;
    });
  }

  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: buildSearchField(),
      body: userDocs == null
          ? Center(
              child: Text(
                "SEARCH FOR VEHICLES",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          : FutureBuilder<QuerySnapshot>(
              future: userDocs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return buildSearchResults(snapshot.data.documents);
                } else {
                  return Container(
                      alignment: FractionalOffset.center,
                      child: CircularProgressIndicator());
                }
              }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class UserSearchItem extends StatelessWidget {
  final User user;

  const UserSearchItem(this.user);

  @override
  Widget build(BuildContext context) {
    TextStyle boldStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    return GestureDetector(
        child: ListTile(
          title: Text(user.name, style: boldStyle),
          subtitle: Text(user.vno),
        ),
        onTap: () {
          openProfile(context, user.name, user.flatno, user.vno, user.phone,
              user.email);
        });
  }
}

void openProfile(BuildContext context, String name, flatno, vno, phone, email) {
  Navigator.of(context)
      .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
    return ProfileScreen();
  }));
}
