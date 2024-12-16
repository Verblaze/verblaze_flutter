import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verblaze_flutter/verblaze_flutter.dart';

abstract class AutoTranslatedWidget extends StatelessWidget {
  const AutoTranslatedWidget({super.key});

  Widget buildView(BuildContext context, VerblazeProvider provider);

  @override
  Widget build(BuildContext context) {
    return Consumer<VerblazeProvider>(builder: (context, provider, child) {
      return buildView(context, provider);
    });
  }
}

abstract class AutoTranslatedStatefulWidget extends StatefulWidget {
  const AutoTranslatedStatefulWidget({super.key});

  @override
  AutoTranslatedState createState();
}

abstract class AutoTranslatedState<T extends AutoTranslatedStatefulWidget>
    extends State<T> {
  Widget buildView(BuildContext context, VerblazeProvider provider);

  @override
  Widget build(BuildContext context) {
    return Consumer<VerblazeProvider>(
      builder: (context, provider, child) {
        return buildView(context, provider);
      },
    );
  }
}
