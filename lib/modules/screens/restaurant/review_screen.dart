import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_rating_app/modules/providers/restaurant_provider.dart';
import 'package:food_rating_app/modules/screens/restaurant/widgets/animation_placeholder.dart';
import 'package:food_rating_app/common/styles.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatelessWidget {
  static const routeName = '/review';

  final String id;
  const ReviewScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _reviewController = TextEditingController();

    Widget _buildForm() {
      return Container(
        margin: const EdgeInsets.all(24.0),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  textAlignVertical: TextAlignVertical.center,
                  showCursor: true,
                  cursorColor: Theme.of(context).iconTheme.color,
                  decoration: InputDecoration(
                    hintText: 'Nama saya',
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.all(16.0),
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .primaryVariant
                        .withOpacity(0.8),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: customBlue,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _reviewController,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  textAlign: TextAlign.justify,
                  showCursor: true,
                  cursorColor: Theme.of(context).iconTheme.color,
                  decoration: InputDecoration(
                    hintText: 'Pendapat saya tentang restoran ini ...',
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.all(16.0),
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .primaryVariant
                        .withOpacity(0.8),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: customBlue,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Review tidak boleh kosong';
                    }
                  },
                ),
              ],
            ),
          )
        ]),
      );
    }

    Widget _buildContent(BuildContext context) {
      return Consumer<ReviewProvider>(
        builder: (context, provider, _) {
          switch (provider.postState) {
            case PostResultState.idle:
              return _buildForm();
            case PostResultState.loading:
              return const Center(
                child: SpinKitFadingCircle(
                  color: customBlue,
                ),
              );

            case PostResultState.success:
              return const Center(
                child: AnimationPlaceholder(
                  animation: 'assets/done.json',
                  text:
                      'Terimakasih sudah memberikan review! Semoga harimu menyenangkan',
                ),
              );
            case PostResultState.failure:
              return Center(
                child: AnimationPlaceholder(
                  animation: 'assets/no-internet.json',
                  text: 'Ops! Sepertinya koneksi internetmu dalam masalah',
                  hasButton: true,
                  buttonText: 'Refresh',
                  onButtonTap: () {
                    provider.setPostState(PostResultState.idle);
                  },
                ),
              );
            default:
              return const SizedBox();
          }
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96.0),
        child: AppBar(
          elevation: 0.0,
          titleSpacing: 24.0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          toolbarHeight: 96.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 24.0,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primaryVariant
                    .withOpacity(0.6),
                child: IconButton(
                  splashRadius: 4.0,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back),
                  color: Theme.of(context).primaryIconTheme.color,
                  onPressed: () {
                    Provider.of<ReviewProvider>(
                      context,
                      listen: false,
                    ).setPostState(PostResultState.idle);
                    Navigator.pop(context);
                  },
                ),
              ),
              Text(
                'Review',
                style: Theme.of(context).appBarTheme.toolbarTextStyle,
              ),
              IconButton(
                splashRadius: 24.0,
                splashColor: Colors.grey[200],
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.send),
                color: Theme.of(context).iconTheme.color,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<ReviewProvider>(
                      context,
                      listen: false,
                    ).postReviewById(
                      id: id,
                      name: _nameController.text,
                      review: _reviewController.text,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(child: _buildContent(context)),
    );
  }
}
