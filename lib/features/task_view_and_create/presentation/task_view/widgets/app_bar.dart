import 'package:done/core/init/data_service/data_service.dart';
import 'package:done/core/init/lang/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class MySliverAppBar2 extends SliverPersistentHeaderDelegate {
  final DataService dataService;
  int _doneCount = 0;
  MySliverAppBar2(this.dataService);
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    _doneCount = dataService.doneCounter();
    double percent = shrinkOffset / (maxExtent - minExtent);
    percent = percent > 1 ? 1 : percent;

    return Container(
      color: const Color.fromRGBO(247, 246, 242, 1),
      child: Stack(
        children: <Widget>[
          _buildTitle(percent),
          _buildLeftImage(percent),
          _buildRightImage(percent),
        ],
      ),
    );
  }

  Widget _buildTitle(double percent) {
    final double top = 147 - (109 * percent);
    const double right = 25;

    return Positioned(
        right: right,
        top: top,
        child: IconButton(
          icon: Icon(
            dataService.withoutDone ? Icons.visibility : Icons.visibility_off,
            size: 27,
            color: const Color.fromRGBO(0, 122, 255, 1),
          ),
          onPressed: () => dataService.changeWithoutDone(),
        ));
  }

  Widget _buildLeftImage(double percent) {
    final double top = 112 - (64 * percent);
    final double left = 65 - (44 * percent);

    return Positioned(
      left: left,
      top: top,
      child: Text(
        LocaleKeys.mydeals.tr(),
        style:
            TextStyle(fontSize: 38 - 14 * percent, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRightImage(double percent) {
    final double top = 162 - (72 * percent);
    final double left = 65 - (44 * percent);

    return Positioned(
        left: left,
        top: top,
        child: Opacity(
          opacity: 1 - 1 * percent,
          child: Text(
            LocaleKeys.completed.tr() + _doneCount.toString(),
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromRGBO(0, 0, 0, 0.3),
            ),
          ),
        ));
  }

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 90;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
