import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:zwalpa/ui/widgets.dart';

class UserDetailUpdateScreen extends StatefulWidget {
  const UserDetailUpdateScreen({super.key});

  @override
  State<UserDetailUpdateScreen> createState() => _UserDetailUpdateScreenState();
}

class _UserDetailUpdateScreenState extends State<UserDetailUpdateScreen> {
  String? language;
  final List<String> languageOptions = [
    'Kannada',
    'Telugu',
    'Hindi',
    'Tamil',
    'Malyalam',
    'English',
    'Urdu',
  ];
  var address = "";
  var subAddress = "";
  bool isLoadingAddress = false;

  final FocusNode _firstNameNode = FocusNode();
  final FocusNode _lastNameNode = FocusNode();
  final FocusNode _ageNode = FocusNode();
  final FocusNode _occupationNode = FocusNode();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _ageController;
  late TextEditingController _occupationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _ageController = TextEditingController();
    _occupationController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
  }

  _determinePosition() async {
    setState(() {
      isLoadingAddress = true;
    });
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      AppSettings.openLocationSettings();

      Fluttertoast.showToast(
          msg: "Location services are disabled.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        isLoadingAddress = false;
      });
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        AppSettings.openLocationSettings();
        Fluttertoast.showToast(
            msg: "Location permissions are denied",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          isLoadingAddress = false;
        });
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      AppSettings.openLocationSettings();
      Fluttertoast.showToast(
          msg:
              "Location permissions are permanently denied, we cannot request permissions.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        isLoadingAddress = false;
      });
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // return await Geolocator.getCurrentPosition();
    Geolocator.getCurrentPosition().then((position) {
      getAddressFromLatLang(position);
    });
  }

  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placemark = await placemarkFromCoordinates(
        position.latitude, position.longitude,
        localeIdentifier: 'en');
    Placemark place = placemark[0];

    setState(() {
      address = "${place.locality}";
      subAddress = "${place.subLocality}";
      log("${address.toString()}, ${subAddress.toString()}");
      isLoadingAddress = false;
    });
  }

  Future<DateTime?> _pickDate(BuildContext context) async {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(DateTime.now().year + 1));
  }

  @override
  Widget build(BuildContext context) {
    var t = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        _firstNameNode.unfocus();
        _lastNameNode.unfocus();
        _occupationNode.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //header
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Let's",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                        ),
                        Text("accomodate you",
                            style: Theme.of(context).textTheme.headline4!),
                      ],
                    ),
                    const Spacer(),
                    Image.asset(
                      'images/Icon.png',
                      scale: 2,
                    )
                  ],
                ),
                SizedBox(
                  height: size.width * 0.2,
                ),
                //body
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Row(
                      children: const [
                        Expanded(
                          child: Text(
                            'System Language',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff767676),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: languageOptions
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: language,
                    onChanged: (value) {
                      setState(() {
                        language = value as String;
                      });
                    },
                    buttonHeight: 50,
                    buttonWidth: size.width,
                    buttonPadding: const EdgeInsets.only(left: 10, right: 14),
                    buttonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: t.backgroundColor,
                    ),
                    dropdownMaxHeight: 200,
                    dropdownWidth: size.width * 0.89,
                    dropdownPadding: null,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: t.backgroundColor,
                    ),
                    dropdownElevation: 8,
                    scrollbarRadius: const Radius.circular(40),
                    scrollbarThickness: 6,
                    scrollbarAlwaysShow: true,
                    offset: const Offset(0, 0),
                  ),
                ),
                Row(
                  children: [
                    BuildTextField(
                        t: t,
                        w: size.width * 0.4,
                        context: context,
                        label: 'Name',
                        hint: "First Name",
                        controller: _firstNameController,
                        node: _firstNameNode,
                        nextNode: _lastNameNode,
                        type: TextInputType.name),
                    const Spacer(),
                    BuildTextField(
                        t: t,
                        w: size.width * 0.4,
                        context: context,
                        label: 'Name',
                        hint: "Last Name",
                        controller: _lastNameController,
                        node: _lastNameNode,
                        nextNode: null,
                        type: TextInputType.name),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    _determinePosition();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: isLoadingAddress == true
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.grey,
                          ))
                        : Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: address.isEmpty
                                    ? const Text(
                                        "Get Location",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff767676),
                                        ),
                                      )
                                    : Text(
                                        "${subAddress.toString()}, ${address.toString()}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: address == ""
                                    ? Icon(
                                        Icons.location_on_outlined,
                                        color: Theme.of(context).disabledColor,
                                      )
                                    : Icon(
                                        Icons.location_on_outlined,
                                        color: Theme.of(context).primaryColor,
                                      ),
                              )
                            ],
                          ),
                  ),
                ),
                SizedBox(
                  height: size.width * 0.15,
                ),

                Text("Optional Details",
                    style: Theme.of(context).textTheme.headline5!),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: size.width,
                  child: GestureDetector(
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.bottom,
                      controller: _ageController,
                      focusNode: _ageNode,
                      keyboardType: TextInputType.none,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                      readOnly: true,
                      onTap: () async {
                        final date = await _pickDate(context);
                        setState(() {
                          _ageController.text =
                              DateFormat('d/M/y').format(date!);
                        });
                        _occupationNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          focusColor: Colors.transparent,
                          filled: true,
                          fillColor: t.backgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none),
                          ),
                          suffixIcon: Icon(
                            Icons.calendar_today_outlined,
                            color: _ageController.text == ""
                                ? t.disabledColor
                                : t.primaryColor,
                          ),
                          hintText: "Date of Birth",
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            color: Color(0xff767676),
                          )),
                    ),
                  ),
                ),
                BuildTextField(
                    t: t,
                    w: size.width,
                    context: context,
                    label: 'Occupation',
                    hint: "Occupation",
                    controller: _occupationController,
                    node: _occupationNode,
                    nextNode: null,
                    type: TextInputType.name),
                SizedBox(
                  height: size.height * 0.1,
                ),
                Center(
                  child: GradientContainer(
                      width: size.width * 0.5,
                      height: 50,
                      borderRadius: 10,
                      child: Center(
                        child: Text(
                          "Proceed",
                          style: t.textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: t.primaryColor,
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
