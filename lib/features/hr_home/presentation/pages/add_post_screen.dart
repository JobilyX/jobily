import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/elevated_button.dart';
import '../../../../core/constant/master_bord_textfiled.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/spaces.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/util/navigator.dart';
import '../../../../core/util/validator.dart';
import '../../../../core/widgets/app_circular_progress_indicator.dart';
import '../../../../core/widgets/toast.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/jobs_repsonse.dart';
import '../cubit/add_post/add_post_cubit.dart';
import '../cubit/get_skills/get_skills_cubit.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key, this.job}) : super(key: key);
  final Job? job;
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final jobTitle = TextEditingController();
  final yearsOfEx = TextEditingController();
  final salaryFrom = TextEditingController();
  final salaryTo = TextEditingController();
  final education = TextEditingController();
  final jobRequirnments = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      jobTitle.text = widget.job!.title;
      yearsOfEx.text = widget.job!.jobSections[yearsOfExperienceIndex].value;
      salaryFrom.text = widget.job!.salaryFrom;
      salaryTo.text = widget.job!.salaryTo;
      education.text = widget.job!.jobSections[fieldEducationIndex].value;
      jobRequirnments.text = widget.job!.description;
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => sl<AddPostCubit>()..initJob(job: widget.job),
        child:
            BlocBuilder<AddPostCubit, AddPostState>(builder: (context, state) {
          final skills = context
              .watch<AddPostCubit>()
              .listOfComp[skillsIndex]
              .sectionvalues
            ..remove("");
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: sidePadding,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hiring post",
                              style: TextStyles.bodyText24
                                  .copyWith(color: darkTextColor),
                            ),
                            const SpaceV20BE(),
                            MasterBorderTextField(
                              controller: jobTitle,
                              text: "Job Title",
                              vaildator: (p0) => Validator.text(p0),
                              keyboardType: TextInputType.number,
                            ),
                            const SpaceV15BE(),
                            MasterBorderTextField(
                                controller: yearsOfEx,
                                text: "Years of experience",
                                vaildator: (p0) => Validator.numbers(p0),
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  context
                                      .read<AddPostCubit>()
                                      .listOfComp[yearsOfExperienceIndex]
                                      .sectionvalues
                                      .first = val;
                                }),
                            const SpaceV15BE(),
                            SizedBox(
                              height: 100,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MasterBorderTextField(
                                        controller: salaryFrom,
                                        text: "Salary from",
                                        vaildator: (p0) =>
                                            Validator.numbers(p0),
                                        keyboardType: TextInputType.number,
                                        onChanged: (val) {}),
                                  ),
                                  const SpaceHBE(),
                                  Expanded(
                                      child: MasterBorderTextField(
                                          controller: salaryTo,
                                          text: "to",
                                          vaildator: (p0) =>
                                              Validator.numbers(p0),
                                          keyboardType: TextInputType.number,
                                          onChanged: (val) {})),
                                ],
                              ),
                            ),
                            MasterDropdown(
                              text: "Job Position",
                              initValue: widget
                                  .job?.jobSections[jobPositionIndex].value,
                              onPick: (val) {
                                if (val != null) {
                                  context
                                      .read<AddPostCubit>()
                                      .listOfComp[jobPositionIndex]
                                      .sectionvalues
                                      .first = val;
                                }
                              },
                              items: context.read<GetSkillsCubit>().jobPosition,
                            ),
                            const SpaceV20BE(),
                            MasterDropdown(
                              text: "Job Location",
                              initValue: widget
                                  .job?.jobSections[jobLocatonIndex].value,
                              onPick: (val) {
                                if (val != null) {
                                  context
                                      .read<AddPostCubit>()
                                      .listOfComp[jobLocatonIndex]
                                      .sectionvalues
                                      .first = val;
                                }
                              },
                              items: context.read<GetSkillsCubit>().jobLocation,
                            ),
                            const SpaceV15BE(),
                            // MasterDropdown(
                            //   text: "Gender",
                            //   onPick: (val) {
                            //     if (val != null) {
                            //        context.read<AddPostCubit>()
                            //           .listOfComp[genderIndex]
                            //           .sectionvalues
                            //           .first = val;
                            //     }
                            //   },
                            //   items: const [
                            //     'male',
                            //     'female',
                            //   ],
                            // ),
                            const SpaceV15BE(),
                            MasterBorderTextField(
                                controller: education,
                                text: "Education",
                                vaildator: (p0) => Validator.text(p0),
                                keyboardType: TextInputType.text,
                                onChanged: (val) {
                                  context
                                      .read<AddPostCubit>()
                                      .listOfComp[fieldEducationIndex]
                                      .sectionvalues
                                      .first = val;
                                }),
                            const SpaceV15BE(),
                            MasterBorderTextField(
                                controller: jobRequirnments,
                                maxLines: 6,
                                maxlength: 90,
                                text: "Job Requirnments",
                                vaildator: (p0) => Validator.text(p0),
                                keyboardType: TextInputType.text,
                                onChanged: (val) {}),
                            const SpaceV15BE(),
                            Text(
                              "Skills",
                              style: TextStyles.bodyText16
                                  .copyWith(color: darkTextColor),
                            ),
                            const SpaceV5BE(),
                            TypeAheadField(
                              hideKeyboardOnDrag: true,
                              hideSuggestionsOnKeyboardHide: false,
                              keepSuggestionsOnLoading: false,
                              loadingBuilder: (context) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(child: indicator),
                                  ),
                                ],
                              ),
                              noItemsFoundBuilder: (context) =>
                                  const SizedBox(),
                              textFieldConfiguration: TextFieldConfiguration(
                                  decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 10.0),
                                filled: true,
                                fillColor: white,
                                errorMaxLines: 2,
                                hintText: tr("pick skill"),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: formFieldBorder,
                                    width: 1,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: formFieldBorder,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: formFieldBorder,
                                    width: 1,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: formFieldBorder,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      style: BorderStyle.solid,
                                    )),
                              )),
                              suggestionsCallback: (value) async {
                                if (value.isNotEmpty) {
                                  return Future.value(sl<GetSkillsCubit>()
                                      .skills
                                      .where((element) => element
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList());
                                }
                                return <String>[];
                                //  cubit.addSerachList(establishments: establishments);
                              },
                              itemBuilder: (context, suggestion) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(suggestion),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                context
                                    .read<AddPostCubit>()
                                    .fAddSkill(suggestion);
                              },
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: skills.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                      mainAxisExtent:
                                          (skills.length ~/ 3) * 4 + 35,
                                    ),
                                    itemBuilder: (context, index) => Chip(
                                          label: Text(skills[index]),
                                          deleteIcon: const Icon(
                                            Icons.cancel,
                                          ),
                                          onDeleted: () {
                                            context
                                                .read<AddPostCubit>()
                                                .fRemoveSkill(skills[index]);
                                          },
                                        )))
                          ],
                        ),
                      ),
                    ),
                    const SpaceV10BE(),
                    BlocConsumer<AddPostCubit, AddPostState>(
                      listener: (context, state) {
                        if (state is AddPostSuccess) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(22.0))),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SpaceV20BE(),
                                      Image.asset(
                                          "assets/images/hr_post_success.png"),
                                      const SpaceV20BE(),
                                      Text(
                                        "Hiring post published successfully, wait applicant responses",
                                        style: TextStyles.bodyText16,
                                      ),
                                      const SpaceV20BE(),
                                      JobilyButton(
                                          onPressed: () {
                                            sl<AppNavigator>().popToFrist();
                                          },
                                          text: "Go Back")
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AddPostLoading) {
                          return const Center(child: indicator);
                        }
                        return JobilyButton(
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              if (context
                                  .read<AddPostCubit>()
                                  .listOfComp[skillsIndex]
                                  .sectionvalues
                                  .isEmpty) {
                                showToast("Pick at leaset one skill");
                                return;
                              }
                              if (int.parse(salaryFrom.text) >=
                                  int.parse(salaryTo.text)) {
                                showToast(
                                    "from salary value must be less than to value");
                                return;
                              }
                              if (context
                                  .read<AddPostCubit>()
                                  .listOfComp[jobLocatonIndex]
                                  .sectionvalues
                                  .isEmpty) {
                                showToast("Pick job location ");
                                return;
                              }
                              if (context
                                  .read<AddPostCubit>()
                                  .listOfComp[jobPositionIndex]
                                  .sectionvalues
                                  .isEmpty) {
                                showToast("Pick job position ");
                                return;
                              }
                              if (widget.job != null) {
                                FocusScope.of(context).unfocus();
                                context.read<AddPostCubit>().fAddPost(
                                    postId: widget.job!.id,
                                    isEdit: true,
                                    title: jobTitle.text,
                                    description: jobRequirnments.text,
                                    salaryFrom: salaryFrom.text,
                                    salaryTo: salaryTo.text);
                                return;
                              }
                              context.read<AddPostCubit>().fAddPost(
                                  isEdit: false,
                                  title: jobTitle.text,
                                  description: jobRequirnments.text,
                                  salaryFrom: salaryFrom.text,
                                  salaryTo: salaryTo.text);
                            },
                            text: widget.job != null ? "Edit" : "Post");
                      },
                    ),
                    const SpaceV40BE(),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}

class MasterDropdown extends StatefulWidget {
  const MasterDropdown(
      {Key? key,
      required this.items,
      required this.text,
      required this.onPick,
      this.initValue})
      : super(key: key);
  final List<String> items;
  final String text;
  final String? initValue;
  final Function(String?) onPick;
  @override
  State<MasterDropdown> createState() => _MasterDropdownState();
}

class _MasterDropdownState extends State<MasterDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue =
        (widget.initValue?.isEmpty ?? true) ? null : widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(widget.text,
            style: TextStyles.bodyText14.copyWith(color: darkTextColor)),
        const SpaceV5BE(),
        DropdownButtonFormField2(
          dropdownMaxHeight: 200,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: formFieldBorder),
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: white,
          ),
          scrollbarAlwaysShow: true,
          isExpanded: true,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.black45,
          ),
          iconSize: 30,
          value: selectedValue,
          buttonHeight: 60,
          buttonPadding: const EdgeInsets.only(left: 20, right: 10),
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          items: widget.items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item,
                        style:
                            TextStyles.bodyText14.copyWith(color: blackColor)),
                  ))
              .toList(),
          validator: (value) {
            if (value == null) {
              return 'Please select gender.';
            }
            return null;
          },
          onChanged: (value) {
            widget.onPick(value);
            //Do something when changing the item if you want.
          },
          onSaved: (value) {
            selectedValue = value.toString();
          },
        ),
      ],
    );
  }
}
