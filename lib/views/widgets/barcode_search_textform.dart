import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BarcodeSearchTextFile extends StatefulWidget {
  BarcodeSearchTextFile(
      {Key? key,
      required this.searchController,
      required this.onChanged,
      this.onScanCompleted,
      this.onSearch})
      : super(key: key);
  TextEditingController searchController;
  void Function(String)? onChanged;
  void Function()? onSearch;
  void Function(String)? onScanCompleted;
  @override
  State<BarcodeSearchTextFile> createState() => _BarcodeSearchTextFileState();
}

class _BarcodeSearchTextFileState extends State<BarcodeSearchTextFile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        child: TextField(
          onEditingComplete: widget.onSearch,
          controller: widget.searchController,
          style: TextStyle(color: Colors.black),
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            prefixIcon: Container(
              child: IconButton(
                  icon: Icon(CupertinoIcons.barcode),
                  onPressed: () async {
                    String barcodeScannerResult = await BarcodeScanner.scan(
                        options: ScanOptions(strings: const {
                      "cancel": "Cancelar",
                      "flash_on": "Flash",
                      "flash_off": "Flash",
                    })).then((value) => value.rawContent);

                    widget.searchController.text = barcodeScannerResult;
                    widget.searchController.value =
                        TextEditingValue(text: barcodeScannerResult);

                    widget.onScanCompleted?.call(barcodeScannerResult);
                  }),
            ),
            suffixIcon: IconButton(
                icon: Icon(Icons.search), onPressed: widget.onSearch),
            prefixIconColor: Colors.black,
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
            hintText: "Buscar",
            labelStyle: TextStyle(color: Colors.black),
            focusColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
