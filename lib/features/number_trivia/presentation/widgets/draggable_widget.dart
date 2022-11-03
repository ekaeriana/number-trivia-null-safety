import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'button_widget.dart';
import 'divider_widget.dart';

class DraggableWidget extends StatefulWidget {
  const DraggableWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<DraggableWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  final TextEditingController controller = TextEditingController();
  late String inputStr;
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .45,
      minChildSize: .45,
      maxChildSize: .45,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                SizedBox(
                  width: 45,
                  height: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Column(
                  children: [
                    const Text(
                      'Search your Number',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Input your number to see fun fact of it',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: controller,
                      onChanged: (value){
                        inputStr = value;
                      },
                      onSubmitted: (value) {
                        addConcrete();
                      },
                      decoration: InputDecoration(
                        hintText: 'Input a number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ButtonWidget(
                      onTap: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        if (controller.text != '') {
                          addConcrete();
                        }
                      },
                      decoration: null,
                      child: const Text(
                        'SEARCH',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5),
                      ),
                    ),
                    const DividerWidget(),
                    ButtonWidget(
                      onTap: addRandom,
                      color: Colors.white,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                      ),
                      child: const Text(
                        'RANDOM NUMBER',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                            letterSpacing: 1.5),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void addConcrete() {
    controller.clear();
    context.read<NumberTriviaBloc>().add(GetTriviaForConcreteNumber(inputStr));
  }

  void addRandom() {
    controller.clear();
    context.read<NumberTriviaBloc>().add(GetTriviaForRandomNumber());
  }
}
