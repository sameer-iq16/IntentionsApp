import 'package:flutter/material.dart';

enum ContentType { text, video, audio }

enum ReminderCadence { daily, weekly, custom, none }

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final String iconName;
  final int intentionCount;
  final int subPathCount;
  final Color backgroundColor;
  final Color iconColor;
  final bool hasSubcategories; // e.g. Family & Relationships = false (direct)

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconName,
    required this.intentionCount,
    required this.subPathCount,
    required this.backgroundColor,
    required this.iconColor,
    this.hasSubcategories = true,
  });

  CategoryModel copyWith({
    String? id,
    String? name,
    IconData? icon,
    String? iconName,
    int? intentionCount,
    int? subPathCount,
    Color? backgroundColor,
    Color? iconColor,
    bool? hasSubcategories,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      iconName: iconName ?? this.iconName,
      intentionCount: intentionCount ?? this.intentionCount,
      subPathCount: subPathCount ?? this.subPathCount,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconColor: iconColor ?? this.iconColor,
      hasSubcategories: hasSubcategories ?? this.hasSubcategories,
    );
  }
}

class SubcategoryModel {
  final String id;
  final String categoryId;
  final String name;
  final IconData icon;
  final String iconName;
  final String description;

  SubcategoryModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.iconName,
    required this.description,
  });

  SubcategoryModel copyWith({
    String? id,
    String? categoryId,
    String? name,
    IconData? icon,
    String? iconName,
    String? description,
  }) {
    return SubcategoryModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      iconName: iconName ?? this.iconName,
      description: description ?? this.description,
    );
  }
}

class SuggestedActionModel {
  final String id;
  final String intentionId;
  final String title;
  final String description;
  final int durationMinutes;
  final String durationDisplay; // "4 min", "2 min", etc. - time shown like price
  final bool isDefaultChecked;

  SuggestedActionModel({
    required this.id,
    required this.intentionId,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.durationDisplay,
    this.isDefaultChecked = true,
  });

  SuggestedActionModel copyWith({
    String? id,
    String? intentionId,
    String? title,
    String? description,
    int? durationMinutes,
    String? durationDisplay,
    bool? isDefaultChecked,
  }) {
    return SuggestedActionModel(
      id: id ?? this.id,
      intentionId: intentionId ?? this.intentionId,
      title: title ?? this.title,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      durationDisplay: durationDisplay ?? this.durationDisplay,
      isDefaultChecked: isDefaultChecked ?? this.isDefaultChecked,
    );
  }
}

class SupportingContentModel {
  final String id;
  final String intentionId;
  final String title;
  final ContentType type;
  final String durationDisplay; // "5 min read", "8 min watch", "6 min listen"
  final String imageUrl;
  final String author;
  final String summary;
  final String fullContent;
  final String? mediaUrl;
  final bool isSaved;

  SupportingContentModel({
    required this.id,
    required this.intentionId,
    required this.title,
    required this.type,
    required this.durationDisplay,
    required this.imageUrl,
    required this.author,
    required this.summary,
    required this.fullContent,
    this.mediaUrl,
    this.isSaved = false,
  });

  SupportingContentModel copyWith({
    String? id,
    String? intentionId,
    String? title,
    ContentType? type,
    String? durationDisplay,
    String? imageUrl,
    String? author,
    String? summary,
    String? fullContent,
    String? mediaUrl,
    bool? isSaved,
  }) {
    return SupportingContentModel(
      id: id ?? this.id,
      intentionId: intentionId ?? this.intentionId,
      title: title ?? this.title,
      type: type ?? this.type,
      durationDisplay: durationDisplay ?? this.durationDisplay,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      summary: summary ?? this.summary,
      fullContent: fullContent ?? this.fullContent,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

class IntentionModel {
  final String id;
  final String categoryId;
  final String? subcategoryId;
  final String title;
  final String topicTag; // e.g. "Patience • Sabr"
  final String description;
  final String whyItMatters;
  final String quote;
  final String quoteReference;
  final IconData icon;
  final String iconName;
  final bool isCustom;
  final bool isFavorite;
  final List<SuggestedActionModel> suggestedActions;
  final List<SupportingContentModel> supportingContent;

  IntentionModel({
    required this.id,
    required this.categoryId,
    this.subcategoryId,
    required this.title,
    required this.topicTag,
    required this.description,
    required this.whyItMatters,
    required this.quote,
    required this.quoteReference,
    required this.icon,
    required this.iconName,
    this.isCustom = false,
    this.isFavorite = false,
    this.suggestedActions = const [],
    this.supportingContent = const [],
  });

  IntentionModel copyWith({
    String? id,
    String? categoryId,
    String? subcategoryId,
    String? title,
    String? topicTag,
    String? description,
    String? whyItMatters,
    String? quote,
    String? quoteReference,
    IconData? icon,
    String? iconName,
    bool? isCustom,
    bool? isFavorite,
    List<SuggestedActionModel>? suggestedActions,
    List<SupportingContentModel>? supportingContent,
  }) {
    return IntentionModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      title: title ?? this.title,
      topicTag: topicTag ?? this.topicTag,
      description: description ?? this.description,
      whyItMatters: whyItMatters ?? this.whyItMatters,
      quote: quote ?? this.quote,
      quoteReference: quoteReference ?? this.quoteReference,
      icon: icon ?? this.icon,
      iconName: iconName ?? this.iconName,
      isCustom: isCustom ?? this.isCustom,
      isFavorite: isFavorite ?? this.isFavorite,
      suggestedActions: suggestedActions ?? this.suggestedActions,
      supportingContent: supportingContent ?? this.supportingContent,
    );
  }
}

class ReminderScheduleModel {
  final String id;
  final String title;
  final ReminderCadence cadence;
  final TimeOfDay timeOfDay;
  final List<int> daysOfWeek; // 1 = Monday, 7 = Sunday
  final List<String> intentionIds;
  final List<String> suggestedActionIds;
  final bool isActive;
  final DateTime createdAt;

  ReminderScheduleModel({
    required this.id,
    required this.title,
    required this.cadence,
    required this.timeOfDay,
    this.daysOfWeek = const [1, 2, 3, 4, 5, 6, 7],
    required this.intentionIds,
    this.suggestedActionIds = const [],
    this.isActive = true,
    required this.createdAt,
  });

  ReminderScheduleModel copyWith({
    String? id,
    String? title,
    ReminderCadence? cadence,
    TimeOfDay? timeOfDay,
    List<int>? daysOfWeek,
    List<String>? intentionIds,
    List<String>? suggestedActionIds,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ReminderScheduleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      cadence: cadence ?? this.cadence,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      intentionIds: intentionIds ?? this.intentionIds,
      suggestedActionIds: suggestedActionIds ?? this.suggestedActionIds,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
