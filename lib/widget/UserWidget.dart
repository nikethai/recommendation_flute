import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recommendation_flute/models/User.dart';
import '../bloc/UserBloc.dart';
import '../models/UserResponse.dart';

class UserWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserWidgetState();
  }
}

class _UserWidgetState extends State<UserWidget> {
  @override
  void initState() {
    super.initState();
    bloc.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserResponse>(
      stream: bloc.subject.stream,
      builder: (context, AsyncSnapshot<UserResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return _buildErrorWidget(snapshot.data.error);
          }
          return _buildUserWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("Loading data from API..."), CircularProgressIndicator()],
    ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }

  Widget _buildUserWidget(UserResponse data) {
    User user = data.results[0];
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage: NetworkImage(user.picture.large),
        ),
        Text(
          "${(user.name.first)} ${(user.name.last)}",
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(user.email, style: Theme.of(context).textTheme.subtitle2),
        Padding(
          padding: EdgeInsets.only(top: 5),
        ),
        Text(user.location.street.name,
            style: Theme.of(context).textTheme.bodyText2),
        Padding(
          padding: EdgeInsets.only(top: 5),
        ),
        Text(user.location.city, style: Theme.of(context).textTheme.bodyText2),
        Padding(
          padding: EdgeInsets.only(top: 5),
        ),
        Text(user.location.state, style: Theme.of(context).textTheme.bodyText2),
      ],
    ));
  }
}
