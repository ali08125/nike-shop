import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/repo/order_repository.dart';
import 'package:nike/ui/record/bloc/record_bloc.dart';
import 'package:nike/ui/widgets/image.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('سوابق سفارش'),
      ),
      body: BlocProvider(
        create: (context) =>
            RecordBloc(orderRepository: orderRepository)..add(RecordStarted()),
        child: BlocBuilder<RecordBloc, RecordState>(
          builder: (context, state) {
            if (state is RecordSuccess) {
              return ListView.builder(
                itemCount: state.record.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 1, color: themeData.dividerColor)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('شناسه سفارش'),
                                  Text(state.record[index].id.toString()),
                                ],
                              ),
                            ),
                            Divider(
                              color: themeData.dividerColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  const Text('مبلغ'),
                                  Text(state.record[index].price
                                      .withPriceLabel())
                                ],
                              ),
                            ),
                            Divider(
                              color: themeData.dividerColor,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              height: 110,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.record[index].products.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index1) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: SizedBox(
                                        width: 110,
                                        height: 110,
                                        child: CashedImage(
                                            imageUrl: state.record[index]
                                                .products[index1].imageUrl)),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is RecordError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else if (state is RecordLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
