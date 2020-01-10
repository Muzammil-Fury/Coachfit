import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class NewsState {

  final List<Map> newsList;
  final Map paginateInfo;
  final Map newsObj;

  const NewsState({
    this.newsList,
    this.paginateInfo,
    this.newsObj
  });

  NewsState copyWith({
    List<Map> newsList,
    Map paginateInfo,
    Map newsObj
  }) {
    return new NewsState(
      newsList: newsList ?? this.newsList,
      paginateInfo: paginateInfo ?? this.paginateInfo,
      newsObj: newsObj ?? this.newsObj      
    );
  }
}
