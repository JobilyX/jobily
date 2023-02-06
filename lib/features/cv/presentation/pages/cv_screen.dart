import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/colors/colors.dart';
import '../../../../core/constant/master_bord_textfiled.dart';
import '../../../../core/constant/size_config.dart';
import '../../../../core/constant/space_between_ele.dart';
import '../../../../core/constant/spaces.dart';
import '../../../../core/constant/styles/styles.dart';
import '../../../../core/util/validator.dart';
import '../../../../core/widgets/app_circular_progress_indicator.dart';
import '../../../../core/widgets/get_image.dart';
import '../../../auth/presentation/cubit/login_cubit/login_cubit.dart';
import '../../../hr_home/presentation/pages/add_post_screen.dart';
import '../cubit/cv_cubit.dart';

class CVScreen extends StatefulWidget {
  const CVScreen({Key? key, this.initStage = 0}) : super(key: key);
  final int initStage;
  @override
  State<CVScreen> createState() => _CVScreenState();
}

class _CVScreenState extends State<CVScreen> {
  @override
  void initState() {
    super.initState();
    stage = widget.initStage;
  }

  int stage = 0;
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();
  Widget getCurrentStage() {
    if (stage == 0) {
      return CVFirstScreen(
        formKey: formKey1,
      );
    }
    if (stage == 1) {
      return CVSecondeScreen(
        formKey: formKey2,
      );
    }
    if (stage == 2) {
      return CVThirdScreen(
        formKey: formKey3,
      );
    } else {
      return CVFourthScreen(
        formKey: formKey4,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<LoginCubit>().user.body.user;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: sidePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr("easy_apply"),
              style: TextStyles.bodyText24,
            ),
            const SpaceV20BE(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                    4,
                    (index) => Container(
                          width: SizeConfig.safeBlockHorizontal * 20,
                          height: 4,
                          decoration: BoxDecoration(
                              color: stage == index
                                  ? accentColor
                                  : stage >= index
                                      ? mainColor
                                      : mainColor.withOpacity(.2),
                              borderRadius: BorderRadius.circular(2)),
                        )),
              ],
            ),
            Expanded(child: SingleChildScrollView(child: getCurrentStage())),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: stage <= 0
                      ? null
                      : () {
                          setState(() {
                            stage--;
                          });
                        },
                  child: Text(
                    tr("pervious"),
                    style: TextStyles.buttonText16.copyWith(
                        color: stage <= 0 ? Colors.grey : accentColor),
                  ),
                ),
                BlocBuilder<CvCubit, CvState>(
                  builder: (context, state) {
                    if (state is CvLoading) {
                      return const Center(
                        child: indicator,
                      );
                    }
                    return TextButton(
                      onPressed: () {
                        if (stage == 3) {
                          if (formKey4.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            context
                                .read<CvCubit>()
                                .fCreateCv(userId: user.id.toString());
                          }
                          return;
                        }
                        switch (stage) {
                          case 0:
                            if (formKey1.currentState!.validate()) {
                              setState(() {
                                stage++;
                              });
                            }
                            break;
                          case 1:
                            if (formKey2.currentState!.validate()) {
                              setState(() {
                                stage++;
                              });
                            }
                            break;
                          case 2:
                            if (context.read<CvCubit>().checkCovers()) {
                              setState(() {
                                stage++;
                              });
                            }
                            break;

                          default:
                        }
                      },
                      child: Text(
                        stage != 3 ? tr("continue") : tr("create"),
                        style:
                            TextStyles.buttonText16.copyWith(color: mainColor),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SpaceV20BE()
          ],
        ),
      ),
    );
  }
}

class CVFirstScreen extends StatefulWidget {
  const CVFirstScreen({Key? key, required this.formKey}) : super(key: key);
  final GlobalKey<FormState> formKey;

  @override
  State<CVFirstScreen> createState() => _CVFirstScreenState();
}

class _CVFirstScreenState extends State<CVFirstScreen> {
  final yearOfExp = TextEditingController();
  final expectedSalary = TextEditingController();
  final previousWork = TextEditingController();
  final jobTitle = TextEditingController();
  @override
  void initState() {
    yearOfExp.text = context
        .read<CvCubit>()
        .listOfComp[yearsOfExperienceIndex]
        .sectionvalues
        .first;
    expectedSalary.text = context
        .read<CvCubit>()
        .listOfComp[expectedSalaryIndex]
        .sectionvalues
        .first;
    previousWork.text = context
        .read<CvCubit>()
        .listOfComp[previousWorkIndex]
        .sectionvalues
        .first;
    jobTitle.text =
        context.read<CvCubit>().listOfComp[jobTitleIndex].sectionvalues.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final listOfComp = context.watch<CvCubit>().listOfComp;
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceV15BE(),
          Text(
            tr("work_experience"),
            style: TextStyles.bodyText16.copyWith(color: darkTextColor),
          ),
          const SpaceV20BE(),
          MasterBorderTextField(
              controller: jobTitle,
              text: "Job Title",
              vaildator: (p0) => Validator.text(p0),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                context
                    .read<CvCubit>()
                    .listOfComp[jobTitleIndex]
                    .sectionvalues
                    .first = val;
              }),
          const SpaceV20BE(),
          MasterDropdown(
            text: "Job Position",
            initValue: listOfComp[jobPositionIndex].sectionvalues.first,
            onPick: (val) {
              if (val != null) {
                context
                    .read<CvCubit>()
                    .listOfComp[jobPositionIndex]
                    .sectionvalues
                    .first = val;
              }
            },
            items: const [
              "CTO",
              "CIO/Chief Digital Officer/Chief Innovation Officer",
              'VP of Product Management/Head of Product',
              'Product Manager',
              'VP of Marketing',
              'VP of Engineering/Director of Engineering',
              'Chief Architect',
              'Software Architect',
              'Engineering Project Manager/Engineering Manager',
              'Technical Lead/Engineering Lead/Team Lead',
              'Principal Software Engineer',
              'Senior Software Engineer/Senior Software Developer',
              'Software Engineer',
              'Software Developer',
              'Junior Software Developer',
              'Intern Software Developer'
            ].reversed.toList(),
          ),
          const SpaceV20BE(),
          MasterDropdown(
            text: "Job Location",
            initValue: listOfComp[jobLocatonIndex].sectionvalues.first,
            onPick: (val) {
              if (val != null) {
                context
                    .read<CvCubit>()
                    .listOfComp[jobLocatonIndex]
                    .sectionvalues
                    .first = val;
              }
            },
            items: const [
              "Full time remote",
              "Full time on-site",
              "Part time remote",
              "Part time on-site"
            ],
          ),
          const SpaceV20BE(),
          MasterBorderTextField(
              controller: yearOfExp,
              text: tr("years_of_experience"),
              vaildator: (p0) => Validator.numbers(p0),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                context
                    .read<CvCubit>()
                    .listOfComp[yearsOfExperienceIndex]
                    .sectionvalues
                    .first = val;
              }),
          const SpaceV20BE(),
          MasterBorderTextField(
              controller: expectedSalary,
              text: tr("expected_salary"),
              vaildator: (p0) => Validator.numbers(p0),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                context
                    .read<CvCubit>()
                    .listOfComp[expectedSalaryIndex]
                    .sectionvalues
                    .first = val;
              }),
          const SpaceV20BE(),
          MasterBorderTextField(
              controller: previousWork,
              text: tr("previous_work"),
              vaildator: (p0) => Validator.text(p0),
              keyboardType: TextInputType.text,
              maxLines: 8,
              onChanged: (val) {
                context
                    .read<CvCubit>()
                    .listOfComp[previousWorkIndex]
                    .sectionvalues
                    .first = val;
              }),
        ],
      ),
    );
  }
}

class CVSecondeScreen extends StatefulWidget {
  const CVSecondeScreen({Key? key, required this.formKey}) : super(key: key);
  final GlobalKey<FormState> formKey;

  @override
  State<CVSecondeScreen> createState() => _CVSecondeScreenState();
}

class _CVSecondeScreenState extends State<CVSecondeScreen> {
  final faculty = TextEditingController();
  final fieldOfEducation = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final deptField = TextEditingController();
  @override
  void initState() {
    faculty.text =
        context.read<CvCubit>().listOfComp[facultyIndex].sectionvalues.first;
    fieldOfEducation.text = context
        .read<CvCubit>()
        .listOfComp[fieldEducationIndex]
        .sectionvalues
        .first;
    startDate.text =
        context.read<CvCubit>().listOfComp[startDateIndex].sectionvalues.first;
    endDate.text =
        context.read<CvCubit>().listOfComp[endDateIndex].sectionvalues.first;
    deptField.text =
        context.read<CvCubit>().listOfComp[deptFieldIndex].sectionvalues.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceV15BE(),
            Text(
              tr("education_language"),
              style: TextStyles.bodyText16.copyWith(color: darkTextColor),
            ),
            const SpaceV40BE(),
            MasterBorderTextField(
              controller: faculty,
              text: tr("what_your_faculty"),
              vaildator: (p0) => Validator.text(p0),
              keyboardType: TextInputType.text,
              onChanged: (val) {
                context
                    .read<CvCubit>()
                    .listOfComp[facultyIndex]
                    .sectionvalues
                    .first = val;
              },
            ),
            const SpaceV40BE(),
            MasterBorderTextField(
              controller: fieldOfEducation,
              text: tr("field_education"),
              vaildator: (p0) => Validator.text(p0),
              keyboardType: TextInputType.text,
              onChanged: (val) {
                context
                    .read<CvCubit>()
                    .listOfComp[fieldEducationIndex]
                    .sectionvalues
                    .first = val;
              },
            ),
            const SpaceV40BE(),
            Row(
              children: [
                Expanded(
                  child: CvDatePicker(
                    controller: startDate,
                    hint: tr("start_date"),
                    index: startDateIndex,
                  ),
                ),
                const SpaceHBE(),
                Expanded(
                  child: CvDatePicker(
                    controller: endDate,
                    hint: tr("end_date"),
                    index: endDateIndex,
                  ),
                ),
              ],
            ),
            const SpaceV40BE(),
            MasterBorderTextField(
              controller: deptField,
              text: tr("dept_field"),
              vaildator: (p0) => Validator.text(p0),
              keyboardType: TextInputType.text,
              onChanged: (val) {
                context
                    .read<CvCubit>()
                    .listOfComp[deptFieldIndex]
                    .sectionvalues
                    .first = val;
              },
            ),
          ],
        ));
  }
}

class CVThirdScreen extends StatelessWidget {
  const CVThirdScreen({Key? key, required this.formKey}) : super(key: key);
  final GlobalKey<FormState> formKey;
  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceV15BE(),
            Text(
              tr("documents"),
              style: TextStyles.bodyText16.copyWith(color: darkTextColor),
            ),
            const SpaceV40BE(),
            const UploadFileBox(
              sectionName: "upload_graduation_certificate",
              index: gradCerIndex,
            ),
            const SpaceV40BE(),
            const UploadFileBox(
              sectionName: "upload_cover_letter",
              index: coverLetterIndex,
            ),
            const SpaceV20BE(),
          ],
        ));
  }
}

class CVFourthScreen extends StatefulWidget {
  const CVFourthScreen({Key? key, required this.formKey}) : super(key: key);
  final GlobalKey<FormState> formKey;

  @override
  State<CVFourthScreen> createState() => _CVFourthScreenState();
}

class _CVFourthScreenState extends State<CVFourthScreen> {
  final skillsController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context
        .read<CvCubit>()
        .listOfComp[skillsIndex]
        .sectionvalues
        .removeWhere((element) => element.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final skills = context.watch<CvCubit>().listOfComp[skillsIndex];
    return Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceV15BE(),
            Text(
              tr("skills"),
              style: TextStyles.bodyText16.copyWith(color: darkTextColor),
            ),
            TextFormField(
              validator: (value) {
                if (skills.sectionvalues.length < 3) {
                  return "skills must be at least 3";
                }
                return null;
              },
              controller:
                  skillsController, //editing controller of this TextField
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.add_box,
                    color: mainColor,
                    size: 30,
                  ),
                  onPressed: () {
                    if (skillsController.text.isNotEmpty) {
                      context.read<CvCubit>().fAddSkill(skillsController.text);
                      skillsController.clear();
                    }
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 10.0),
                filled: false,
                errorMaxLines: 2,
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
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: errorColor,
                      width: 1,
                      style: BorderStyle.solid,
                    )),
                hintStyle: TextStyles.bodyText14.copyWith(color: Colors.grey),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: skills.sectionvalues.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      mainAxisExtent:
                          (skills.sectionvalues.length ~/ 3) * 4 + 35,
                    ),
                    itemBuilder: (context, index) => Chip(
                          label: Text(skills.sectionvalues[index]),
                          deleteIcon: const Icon(
                            Icons.cancel,
                          ),
                          onDeleted: () {
                            context
                                .read<CvCubit>()
                                .fRemoveSkill(skills.sectionvalues[index]);
                          },
                        )))
          ],
        ));
  }
}

class UploadFileBox extends StatefulWidget {
  const UploadFileBox(
      {Key? key, required this.sectionName, required this.index})
      : super(key: key);
  final String sectionName;
  final int index;
  @override
  State<UploadFileBox> createState() => _UploadFileBoxState();
}

class _UploadFileBoxState extends State<UploadFileBox> {
  @override
  void initState() {
    super.initState();
    context.read<CvCubit>().checkCovers();
    if (context.read<CvCubit>().listOfComp[widget.index] is FileCvComponent &&
        (context.read<CvCubit>().listOfComp[widget.index] as FileCvComponent)
                .file !=
            null) {
      file =
          (context.read<CvCubit>().listOfComp[widget.index] as FileCvComponent)
              .file;
    } else if (context
        .read<CvCubit>()
        .listOfComp[widget.index]
        .sectionvalues
        .first
        .isNotEmpty) {
      image =
          context.read<CvCubit>().listOfComp[widget.index].sectionvalues.first;
    }
  }

  File? file;
  String? image;
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(tr(widget.sectionName),
              style: TextStyles.bodyText14.copyWith(color: darkTextColor)),
          const SpaceV10BE(),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  elevation: 3,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
                  context: context,
                  builder: (_) {
                    return GetImageFromCameraAndGellary(onPickImage: (img) {
                      context.read<CvCubit>().listOfComp[widget.index] =
                          FileCvComponent(sectionName: widget.sectionName);

                      (context.read<CvCubit>().listOfComp[widget.index]
                              as FileCvComponent)
                          .file = img;
                      context.read<CvCubit>().checkCovers();
                      setState(() {
                        file = img;
                      });
                    });
                  });
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: formFieldBorder),
                  borderRadius: BorderRadius.circular(10)),
              child: file != null
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.transparent,
                          backgroundImage: FileImage(
                            file!,
                          ),
                        ),
                      ),
                      const SpaceHBE(),
                      Text(
                        tr("upload_text"),
                        style: TextStyles.bodyText14.copyWith(
                            color: const Color(0xff3B576F).withOpacity(.5)),
                      )
                    ])
                  : image != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(
                                    image!,
                                  ),
                                ),
                              ),
                              const SpaceHBE(),
                              Text(
                                tr("upload_text"),
                                style: TextStyles.bodyText14.copyWith(
                                    color: const Color(0xff3B576F)
                                        .withOpacity(.5)),
                              )
                            ])
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Icon(Icons.upload_file_sharp,
                                  color:
                                      const Color(0xff3B576F).withOpacity(.5)),
                              const SpaceHBE(),
                              Text(
                                tr("upload_text"),
                                style: TextStyles.bodyText14.copyWith(
                                    color: const Color(0xff3B576F)
                                        .withOpacity(.5)),
                              )
                            ]),
            ),
          ),
          const SpaceV10BE(),
          if (!context.watch<CvCubit>().getCoverVaildation(widget.index))
            Text(
              tr("error_filed_required"),
              style: TextStyles.bodyText16.copyWith(color: errorColor),
            )
        ]);
  }
}

class CvDatePicker extends StatefulWidget {
  const CvDatePicker(
      {Key? key,
      required this.controller,
      required this.index,
      required this.hint})
      : super(key: key);
  final TextEditingController controller;
  final int index;
  final String hint;
  @override
  State<CvDatePicker> createState() => _CvDatePickerState();
}

class _CvDatePickerState extends State<CvDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(widget.hint,
            style: TextStyles.bodyText14.copyWith(color: darkTextColor)),
        const SpaceV5BE(),
        Center(
          child: TextFormField(
            validator: (value) => Validator.defaultValidator(value),
            controller:
                widget.controller, //editing controller of this TextField
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
              filled: false,
              errorMaxLines: 2,
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
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: errorColor,
                    width: 1,
                    style: BorderStyle.solid,
                  )),
              hintStyle: TextStyles.bodyText14.copyWith(color: Colors.grey),
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(1999),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now());

              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yMMMM', "en").format(pickedDate);
                setState(() {
                  widget.controller.text = formattedDate;
                  context
                          .read<CvCubit>()
                          .listOfComp[widget.index]
                          .sectionvalues
                          .first =
                      formattedDate; //set output date to TextField value.
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
