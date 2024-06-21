import 'package:dynamic_searchbar/dynamic_searchbar.dart';

class ListFilters {
  final List<FilterAction> birdSort = [
    FilterAction(
      title: 'Firstname ASC',
      field: 'firstname',
    ),
    FilterAction(
      title: 'Lastname ASC',
      field: 'lastname',
    ),
    FilterAction(
      title: 'Email DESC',
      field: 'email',
    ),
    FilterAction(
      title: 'Position DESC',
      field: 'position',
    ),
    FilterAction(
      title: 'Hired date ASC',
      field: 'hiredDate',
    ),
    FilterAction(
      title: 'Hired date DESC',
      field: 'hiredDate',
    ),
  ];
}
