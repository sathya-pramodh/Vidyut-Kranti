import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({
    super.key,
    required this.searchTitle,
    required this.inputHintText,
    required this.dropdownController,
    required this.optionList,
  });
  final String searchTitle;
  final String inputHintText;
  final Function dropdownController;
  final List<String> optionList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ).copyWith(
        bottom: 14,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // color: Colors.white,
        color: Color.fromARGB(255, 195, 209, 234),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          searchTitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(
            top: 12,
          ),
          padding: const EdgeInsets.only(
            top: 4,
            left: 10,
            right: 8,
          ),
          height: 44,
          decoration: BoxDecoration(
            color: Color.fromARGB(87, 57, 72, 103),
            borderRadius: BorderRadius.circular(8),
          ),
          // child: TextField(
          //   style: const TextStyle(
          //     color: Colors.black,
          //     fontSize: 18,
          //   ),
          //   cursorColor: Color(0xFF9BA4B5),
          //   cursorRadius: const Radius.circular(20),
          //   decoration: InputDecoration(
          //     // label: Text('Search destination'),
          //     hintText: inputHintText,
          //     hintStyle: const TextStyle(
          //       color: Colors.white,
          //     ),
          //     border: InputBorder.none,
          //     suffixIcon: IconButton(
          //       icon: const Icon(
          //         Icons.arrow_drop_down_circle_outlined,
          //         color: Colors.white,
          //       ),
          //       onPressed: () {},
          //     ),
          //   ),
          // ),

          //dropdown search 5.0.6:

          child: DropdownSearch(
            enabled: true,
            items: optionList,
            onChanged: (value) {
              // print(value);
              dropdownController(value);
            },
            // selectedItem: searchTitle,

            popupProps: PopupProps.menu(
              emptyBuilder: (context, searchEntry) => Center(
                child: Text(
                  'No result found',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              searchFieldProps: TextFieldProps(
                showCursor: true,
                cursorColor: Color(0xFF212A3E),
                decoration: InputDecoration(
                  label: Text('Search'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.blueGrey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 104, 186, 226),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              scrollbarProps: ScrollbarProps(
                thickness: 3,
                radius: Radius.circular(6),
                thumbColor: Color(0xFF212A3E),
                interactive: true,
              ),

              containerBuilder: (context, popupWidget) => Container(
                color: Color.fromARGB(255, 195, 209, 234),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: popupWidget,
                ),
              ),
              favoriteItemProps: FavoriteItemProps(),
              loadingBuilder: (context, searchEntry) => Center(
                child: Column(
                  children: [
                    Text(
                      'Fetching results...',
                    ),
                    CircularProgressIndicator(
                      color: Color(0xFF212A3E),
                    )
                  ],
                ),
              ),
              // showSelectedItems: true,
              showSearchBox: true,
              fit: FlexFit.loose,
              listViewProps: ListViewProps(
                addAutomaticKeepAlives: true,
                addSemanticIndexes: true,
                // itemExtent: 55,
                addRepaintBoundaries: true,
              ),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: inputHintText,
                border: InputBorder.none,
              ),
              baseStyle: TextStyle(
                fontSize: 17,
              ),
            ),
            // autoValidateMode: AutovalidateMode.always,

            dropdownButtonProps: DropdownButtonProps(
              color: Colors.black,
              isSelected: true,
              alignment: Alignment.center,
              autofocus: true,
            ),
            // dropdownBuilder: (context, selectedItem) => DropdownMenuItem(
            //   child: Container(
            //     child: Text(
            //       selectedItem != null ? selectedItem : searchTitle,
            //       style: TextStyle(
            //         fontSize: 16,
            //       ),
            //     ),
            //   ),
            // ),
            clearButtonProps: const ClearButtonProps(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
