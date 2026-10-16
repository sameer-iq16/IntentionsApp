import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class SampleData {
  static List<CategoryModel> getCategories() {
    return [
      CategoryModel(
        id: 'cat_personal',
        name: 'Personal Development',
        icon: Icons.cottage_outlined,
        iconName: 'cottage',
        intentionCount: 18,
        subPathCount: 4,
        backgroundColor: AppColors.secondaryContainer.withValues(alpha: 0.5),
        iconColor: AppColors.primary,
        hasSubcategories: true,
      ),
      CategoryModel(
        id: 'cat_character',
        name: 'Character & Manners',
        icon: Icons.person_outline,
        iconName: 'person',
        intentionCount: 24,
        subPathCount: 5,
        backgroundColor: AppColors.roseBg,
        iconColor: AppColors.roseIcon,
        hasSubcategories: true,
      ),
      CategoryModel(
        id: 'cat_family',
        name: 'Family & Relationships',
        icon: Icons.favorite_outline,
        iconName: 'favorite',
        intentionCount: 14,
        subPathCount: 0,
        backgroundColor: AppColors.peachBg,
        iconColor: AppColors.peachIcon,
        hasSubcategories: false, // Direct intentions! No subcategories
      ),
      CategoryModel(
        id: 'cat_health',
        name: 'Health & Wellbeing',
        icon: Icons.health_and_safety_outlined,
        iconName: 'health_and_safety',
        intentionCount: 16,
        subPathCount: 3,
        backgroundColor: AppColors.skyBg,
        iconColor: AppColors.skyIcon,
        hasSubcategories: true,
      ),
      CategoryModel(
        id: 'cat_work',
        name: 'Work & Study',
        icon: Icons.school_outlined,
        iconName: 'school',
        intentionCount: 21,
        subPathCount: 4,
        backgroundColor: AppColors.primaryFixed,
        iconColor: AppColors.primary,
        hasSubcategories: true,
      ),
      CategoryModel(
        id: 'cat_finances',
        name: 'Finances & Wealth',
        icon: Icons.account_balance_wallet_outlined,
        iconName: 'account_balance_wallet',
        intentionCount: 11,
        subPathCount: 2,
        backgroundColor: AppColors.amberBg,
        iconColor: AppColors.amberIcon,
        hasSubcategories: true,
      ),
    ];
  }

  static List<SubcategoryModel> getSubcategories() {
    return [
      // Character & Manners
      SubcategoryModel(
        id: 'sub_patience',
        categoryId: 'cat_character',
        name: 'Being Patient',
        icon: Icons.hourglass_empty,
        iconName: 'hourglass_empty',
        description: 'Cultivate Sabr in trials, speech, and daily challenges',
      ),
      SubcategoryModel(
        id: 'sub_speech',
        categoryId: 'cat_character',
        name: 'Soft Speech & Kindness',
        icon: Icons.favorite_border,
        iconName: 'favorite',
        description: 'Speak truthful, gentle words that soothe hearts',
      ),
      SubcategoryModel(
        id: 'sub_forgiveness',
        categoryId: 'cat_character',
        name: 'Forgiving Others',
        icon: Icons.handshake_outlined,
        iconName: 'handshake',
        description: 'Pardon faults readily to earn Allah’s vast mercy',
      ),
      // Personal Development
      SubcategoryModel(
        id: 'sub_reflection',
        categoryId: 'cat_personal',
        name: 'Self-Reflection (Muhasabah)',
        icon: Icons.psychology_outlined,
        iconName: 'psychology',
        description: 'Daily accounting of deeds, sincerity, and inner state',
      ),
      SubcategoryModel(
        id: 'sub_focus',
        categoryId: 'cat_personal',
        name: 'Mindful Intentionality',
        icon: Icons.center_focus_strong_outlined,
        iconName: 'center_focus_strong',
        description: 'Purifying intentions before every project and meeting',
      ),
      // Health & Wellbeing
      SubcategoryModel(
        id: 'sub_nourish',
        categoryId: 'cat_health',
        name: 'Body as an Amanah',
        icon: Icons.eco_outlined,
        iconName: 'eco',
        description: 'Mindful wholesome nutrition and honoring the physical vessel',
      ),
      // Work & Study
      SubcategoryModel(
        id: 'sub_ihsan',
        categoryId: 'cat_work',
        name: 'Excellence & Ihsan',
        icon: Icons.auto_awesome_outlined,
        iconName: 'auto_awesome',
        description: 'Performing tasks with perfection as if seeing the Divine',
      ),
    ];
  }

  static List<IntentionModel> getIntentions() {
    return [
      // Patience 1
      IntentionModel(
        id: 'int_patient_1',
        categoryId: 'cat_character',
        subcategoryId: 'sub_patience',
        title: "To seek Allah's pleasure through patience.",
        topicTag: "Patience • Sabr",
        description:
            "Patience is not just about enduring difficulties, but about actively seeking Allah’s pleasure in the unfolding process. It anchors our soul to His divine decree, helping us remain grounded, trusting in His greater wisdom, and uncovering serenity in every moment.",
        whyItMatters:
            "It transforms passive struggle into rewarded spiritual devotion, protects the heart from bitterness, and brings enduring inner peace.",
        quote: "“Indeed, Allah is with the patient.”",
        quoteReference: "Surah Al-Baqarah (2:153)",
        icon: Icons.mosque_outlined,
        iconName: 'mosque',
        suggestedActions: [
          SuggestedActionModel(
            id: 'act_1_1',
            intentionId: 'int_patient_1',
            title: "Remind yourself of Allah's presence in difficult moments",
            description: "Pause in difficult moments and recite Istighfar.",
            durationMinutes: 4,
            durationDisplay: "4 min",
            isDefaultChecked: true,
          ),
          SuggestedActionModel(
            id: 'act_1_2',
            intentionId: 'int_patient_1',
            title: "Keep making du'a for patience and clarity",
            description: "Turn directly to Allah before reacting.",
            durationMinutes: 3,
            durationDisplay: "3 min",
            isDefaultChecked: true,
          ),
          SuggestedActionModel(
            id: 'act_1_3',
            intentionId: 'int_patient_1',
            title: "Focus on what you control and surrender the rest",
            description: "Release outcome anxiety and trust His decree.",
            durationMinutes: 2,
            durationDisplay: "2 min",
            isDefaultChecked: true,
          ),
          SuggestedActionModel(
            id: 'act_1_4',
            intentionId: 'int_patient_1',
            title: "Pause for a slow breath before reacting in anger",
            description: "Follow the prophetic guidance to pause and change posture.",
            durationMinutes: 1,
            durationDisplay: "1 min",
            isDefaultChecked: false,
          ),
        ],
        supportingContent: [
          SupportingContentModel(
            id: 'cnt_1_1',
            intentionId: 'int_patient_1',
            title: "The power of patience in Islam",
            type: ContentType.text,
            durationDisplay: "5 min read",
            imageUrl: "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=600&q=80",
            author: "Imam Al-Ghazali Insights",
            summary: "Understanding the three stations of Sabr: patience upon obedience, patience against sin, and patience through decree.",
            fullContent: """Patience (Sabr) is universally revered in the Islamic tradition as half of faith. 

When trials present themselves, the natural impulse of the human ego is resistance, frustration, or panic. Yet the spiritual master recognizes that every circumstance—both sweet and bitter—is a deliberate teacher sent by divine wisdom.

The three primary forms of patience are:
1. Sabr in fulfilling obligations: Waking up for Fajr in the chill of the morning, standing in night prayer, and persevering in charity.
2. Sabr against harmful desires: Restraining the tongue from backbiting, anger, and petty arguments.
3. Sabr during trials and loss: Accepting that life's ebb and flow are tests of trust, knowing that with every hardship comes ease.

When you practice patience with an intentional heart (Niyyah), the act transforms from painful endurance into sweet worship.""",
          ),
          SupportingContentModel(
            id: 'cnt_1_2',
            intentionId: 'int_patient_1',
            title: "Patience in everyday life",
            type: ContentType.video,
            durationDisplay: "8 min watch",
            imageUrl: "https://images.unsplash.com/photo-1519817650390-64a93db51149?auto=format&fit=crop&w=600&q=80",
            author: "Mindful Believer Studio",
            summary: "How to apply prophetic calm in modern high-pressure environments like commuting, work deadlines, and family tension.",
            fullContent: """In this practical masterclass, we explore micro-habits to anchor prophetic composure in 21st-century daily situations.

Key Takeaways:
• The 5-second silence rule before replying to an irritating message.
• How changing your physical posture (sitting if standing, lying down if sitting) resets the nervous system.
• Converting traffic jams or waiting queues into silent dhikr sanctuaries.""",
          ),
          SupportingContentModel(
            id: 'cnt_1_3',
            intentionId: 'int_patient_1',
            title: "Finding peace through patience",
            type: ContentType.audio,
            durationDisplay: "6 min listen",
            imageUrl: "https://images.unsplash.com/photo-1470240731273-7821a6eeb6bd?auto=format&fit=crop&w=600&q=80",
            author: "Voice of Tranquility",
            summary: "A soothing audio reflection with contemplative recitation on trusting the divine timing of your life.",
            fullContent: """A gentle guided reflection to listen to whenever you feel overwhelmed by unexpected obstacles.

Breathe in the assurance that Allah does not burden a soul beyond what it can bear. With every breath, exhale resentment and inhale peace.""",
          ),
          SupportingContentModel(
            id: 'cnt_1_4',
            intentionId: 'int_patient_1',
            title: "Practical tips for building patience",
            type: ContentType.text,
            durationDisplay: "4 min read",
            imageUrl: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=600&q=80",
            author: "Habit Psychology & Sunnah",
            summary: "Concrete neuro-behavioral steps paired with prophetic guidance to expand emotional stamina.",
            fullContent: """Patience is not an unchangeable personality trait; it is a spiritual and emotional muscle that strengthens with regular progressive training.

Step 1: Notice your physical trigger cues (tight chest, clenched jaw).
Step 2: Ground yourself with a deep diaphragmatic breath.
Step 3: Repeat 'La hawla wa la quwwata illa billah' (There is no power nor strength except through Allah).
Step 4: Shift from reactive blame to proactive curiosity.""",
          ),
        ],
      ),
      // Patience 2
      IntentionModel(
        id: 'int_patient_2',
        categoryId: 'cat_character',
        subcategoryId: 'sub_patience',
        title: "To seek Allah's reward when facing difficulty.",
        topicTag: "Patience • Trials",
        description: "Viewing hardships not as penalties, but as opportunities for spiritual elevation and sin expiation.",
        whyItMatters: "Removes bitterness from painful experiences and restores hope in ultimate divine justice and compensation.",
        quote: "“No fatigue, illness, anxiety, or sadness afflicts a believer except that Allah expiates sins thereby.”",
        quoteReference: "Sahih al-Bukhari 5641",
        icon: Icons.landscape_outlined,
        iconName: 'landscape',
        suggestedActions: [
          SuggestedActionModel(
            id: 'act_2_1',
            intentionId: 'int_patient_2',
            title: "Say Inna Lillahi wa Inna Ilayhi Raji'un",
            description: "Declare return to Allah at the very initial shock.",
            durationMinutes: 1,
            durationDisplay: "1 min",
          ),
          SuggestedActionModel(
            id: 'act_2_2',
            intentionId: 'int_patient_2',
            title: "Ask Allah for better compensation",
            description: "Recite the supplication of Umm Salamah with full certainty.",
            durationMinutes: 2,
            durationDisplay: "2 min",
          ),
        ],
      ),
      // Patience 3
      IntentionModel(
        id: 'int_patient_3',
        categoryId: 'cat_character',
        subcategoryId: 'sub_patience',
        title: "To strengthen my faith and reliance on Allah during hardship.",
        topicTag: "Patience • Tawakkul",
        description: "Cultivating unshakeable confidence in Allah’s guardianship when external safety nets fail.",
        whyItMatters: "Builds inner emotional resilience that cannot be shattered by worldly storms.",
        quote: "“And whoever relies upon Allah - then He is sufficient for him.”",
        quoteReference: "Surah At-Talaq (65:3)",
        icon: Icons.front_hand_outlined,
        iconName: 'front_hand',
        suggestedActions: [
          SuggestedActionModel(
            id: 'act_3_1',
            intentionId: 'int_patient_3',
            title: "Morning surrender prayer",
            description: "Surrender personal worries into Allah's gentle care during morning quiet.",
            durationMinutes: 3,
            durationDisplay: "3 min",
          ),
          SuggestedActionModel(
            id: 'act_3_2',
            intentionId: 'int_patient_3',
            title: "Journal 3 blessings hidden in trials",
            description: "Active gratitude reflection during difficult weeks.",
            durationMinutes: 5,
            durationDisplay: "5 min",
          ),
        ],
      ),
      // Patience 4
      IntentionModel(
        id: 'int_patient_4',
        categoryId: 'cat_character',
        subcategoryId: 'sub_patience',
        title: "To accept Allah's decree with patience and trust in His wisdom.",
        topicTag: "Patience • Rida",
        description: "Attaining peace of heart with what is written, recognizing that divine knowledge exceeds human sight.",
        whyItMatters: "Shields against despair and perpetual anxiety over what could have been.",
        quote: "“Perhaps you hate a thing and it is good for you; and perhaps you love a thing and it is bad for you.”",
        quoteReference: "Surah Al-Baqarah (2:216)",
        icon: Icons.yard_outlined,
        iconName: 'yard',
        suggestedActions: [
          SuggestedActionModel(
            id: 'act_4_1',
            intentionId: 'int_patient_4',
            title: "Affirm: 'Qaddar Allah wa ma sha'a fa'al'",
            description: "Utter the prophetic phrase whenever plans deviate.",
            durationMinutes: 1,
            durationDisplay: "1 min",
          ),
        ],
      ),
      // Patience 5
      IntentionModel(
        id: 'int_patient_5',
        categoryId: 'cat_character',
        subcategoryId: 'sub_patience',
        title: "To be humble in adversity and grow closer to Allah and purify myself.",
        topicTag: "Patience • Humility",
        description: "Allowing life’s challenges to soften the heart rather than harden it into arrogance or cynicism.",
        whyItMatters: "Purifies character and invites divine affection and proximity.",
        quote: "“The servants of the Merciful are those who walk upon the earth easily.”",
        quoteReference: "Surah Al-Furqan (25:63)",
        icon: Icons.favorite_border,
        iconName: 'favorite_border',
        suggestedActions: [
          SuggestedActionModel(
            id: 'act_5_1',
            intentionId: 'int_patient_5',
            title: "Offer two quiet rak'ahs in gratitude",
            description: "Pray two rak'ahs when facing stress to regain center.",
            durationMinutes: 6,
            durationDisplay: "6 min",
          ),
        ],
      ),
      // Patience 6
      IntentionModel(
        id: 'int_patient_6',
        categoryId: 'cat_character',
        subcategoryId: 'sub_patience',
        title: "To develop patience as part of becoming a better Muslim and person.",
        topicTag: "Patience • Self Growth",
        description: "Treating patience as a deliberate life skill for spiritual and personal mastery.",
        whyItMatters: "Produces sustainable discipline, compassionate relationships, and inner composure.",
        quote: "“Whoever tries to be patient, Allah will give him patience.”",
        quoteReference: "Sahih al-Bukhari 1469",
        icon: Icons.self_improvement_outlined,
        iconName: 'self_improvement',
        suggestedActions: [
          SuggestedActionModel(
            id: 'act_6_1',
            intentionId: 'int_patient_6',
            title: "Practice mindful listening before speaking",
            description: "Listen without interrupting for a full conversation.",
            durationMinutes: 5,
            durationDisplay: "5 min",
          ),
        ],
      ),

      // DIRECT CATEGORY: Family & Relationships (NO SUBCATEGORIES)
      IntentionModel(
        id: 'int_fam_1',
        categoryId: 'cat_family',
        subcategoryId: null, // Direct intention
        title: "To treat my parents with boundless compassion and gentle speech.",
        topicTag: "Family • Parents",
        description: "Fulfilling filial devotion (Birr al-Walidayn) with unconditional warmth, honoring their sacrifice.",
        whyItMatters: "One of the most beloved deeds in Islam and the highest doorway to Paradise.",
        quote: "“And lower to them the wing of humility out of mercy and say, 'My Lord, have mercy upon them as they brought me up when I was small.'”",
        quoteReference: "Surah Al-Isra (17:24)",
        icon: Icons.family_restroom_outlined,
        iconName: 'family_restroom',
        suggestedActions: [
          SuggestedActionModel(
            id: 'act_fam_1_1',
            intentionId: 'int_fam_1',
            title: "Call or visit parents with genuine warmth",
            description: "Ask about their health and listen without rushing.",
            durationMinutes: 10,
            durationDisplay: "10 min",
          ),
          SuggestedActionModel(
            id: 'act_fam_1_2',
            intentionId: 'int_fam_1',
            title: "Make heartfelt du'a for their forgiveness",
            description: "Recite the Quranic prayer for parents after prayer.",
            durationMinutes: 2,
            durationDisplay: "2 min",
          ),
        ],
        supportingContent: [
          SupportingContentModel(
            id: 'cnt_fam_1',
            intentionId: 'int_fam_1',
            title: "The high station of parents in the Quran",
            type: ContentType.text,
            durationDisplay: "6 min read",
            imageUrl: "https://images.unsplash.com/photo-1511895426328-dc8714191300?auto=format&fit=crop&w=600&q=80",
            author: "Family Wisdom Institute",
            summary: "Deepening your heart's reverence for parents even in moments of generational disagreement.",
            fullContent: """The Quran uniquely links the worship of Allah with gratitude toward one's parents. 

Even when parents age and become frail or testy, the believer is cautioned: 'Do not say to them so much as 'uff' (a sigh of irritation), nor repel them, but speak to them a noble word.'""",
          ),
        ],
      ),
      IntentionModel(
        id: 'int_fam_2',
        categoryId: 'cat_family',
        subcategoryId: null, // Direct intention
        title: "To bring tranquil affection and peace into my marital home.",
        topicTag: "Family • Spousal Love",
        description: "Cultivating Mawaddah (deep affectionate love) and Rahmah (mercy) in everyday domestic interactions.",
        whyItMatters: "Transforms everyday marital partnership into an oasis of spiritual and emotional shelter.",
        quote: "“And among His signs is that He created for you mates from among yourselves, that you may find tranquility in them.”",
        quoteReference: "Surah Ar-Rum (30:21)",
        icon: Icons.volunteer_activism_outlined,
        iconName: 'volunteer_activism',
        suggestedActions: [
          SuggestedActionModel(
            id: 'act_fam_2_1',
            intentionId: 'int_fam_2',
            title: "Express sincere verbal appreciation",
            description: "Thank your spouse for specific unnoticed daily efforts.",
            durationMinutes: 3,
            durationDisplay: "3 min",
          ),
        ],
      ),
      IntentionModel(
        id: 'int_fam_3',
        categoryId: 'cat_family',
        subcategoryId: null, // Direct intention
        title: "To forgive family shortcomings and sustain kinship ties (Silat ar-Rahim).",
        topicTag: "Family • Kinship",
        description: "Bridging relational rifts and actively checking upon relatives, especially those who stay distant.",
        whyItMatters: "Extends life blessings, invites divine companionship, and clears heart blockages.",
        quote: "“Whoever loves that he be granted more wealth and that his life be prolonged, then let him maintain relations with his kith and kin.”",
        quoteReference: "Sahih al-Bukhari 5986",
        icon: Icons.diversity_3_outlined,
        iconName: 'diversity_3',
        suggestedActions: [
          SuggestedActionModel(
            id: 'act_fam_3_1',
            intentionId: 'int_fam_3',
            title: "Send a friendly check-in message to a distant relative",
            description: "Reach out with greetings and prayers with zero expectation of return.",
            durationMinutes: 2,
            durationDisplay: "2 min",
          ),
        ],
      ),
    ];
  }

  static List<ReminderScheduleModel> getReminders() {
    return [
      ReminderScheduleModel(
        id: 'rem_1',
        title: 'Be Patient',
        cadence: ReminderCadence.daily,
        timeOfDay: const TimeOfDay(hour: 9, minute: 0),
        daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
        intentionIds: ['int_patient_1', 'int_patient_2'],
        suggestedActionIds: ['act_1_1'],
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
}
