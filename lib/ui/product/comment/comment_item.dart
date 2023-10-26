
import 'package:flutter/material.dart';
import 'package:nike/data/comment.dart';

class CommentItem extends StatelessWidget {
  final CommentEntity comment;
  const CommentItem({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.title),
                    Text(
                      comment.email,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
                Text(
                  comment.date,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Text(comment.content)
          ],
        ),
      ),
    );
  }
}
