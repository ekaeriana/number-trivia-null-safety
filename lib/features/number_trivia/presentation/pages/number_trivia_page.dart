import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../presentation/bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blue,
      body: _body(size),
    );
  }

  BlocProvider<NumberTriviaBloc>? _body(MediaQueryData mediaQuery) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  title(),
                  const SizedBox(height: 50),
                  BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                      if (state is Empty) {
                        return const MessageDisplay(msg: 'Start Searching');
                      } else if (state is Loading) {
                        return const LoadingState();
                      } else if (state is Loaded) {
                        return TriviaDisplay(trivia: state.trivia);
                      } else if (state is Error) {
                        return MessageDisplay(msg: state.message);
                      } else {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          child: const Placeholder(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const DraggableWidget()
          ],
        ),
      ),
    );
  }

  Column title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Icon(
          Icons.numbers,
          color: Colors.white,
          size: 24,
        ),
        SizedBox(height: 20),
        Text(
          'Number Trivia',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          'Find facts about your number',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              color: Colors.white),
        ),
      ],
    );
  }
}
