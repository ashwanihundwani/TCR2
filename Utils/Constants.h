
#import "PersistenceStorage.h"
#import "ConstantStrings.h"
#import "Utils.h"

#define LABEL_BLUE_TEXT_COLOR_HEX_VALUE @"007EF6"
#define NAV_BAR_BLACK_COLOR @"F7F7F7"
#define BUTTON_BLUE_COLOR_HEX_VALUE @"007AFF"

#define DELETE_ALERT_TITLE @"Do you want to delete this?"
#define DELETE_ALERT_POSITIVE_BUTTON_TITLE @"Yes"
#define DELETE_ALERT_NEGATIVE_BUTTON_TITLE @"No"


#define TITLE_LABEL_WIDTH 276
#define TITLE_LABEL_FONT_SIZE 15
#define TITLE_LABEL_FONT [Utils helveticaNueueFontWithSize:15]

#define SUB_TITLE_LABEL_WIDTH 276
#define SUB_TITLE_LABEL_FONT_SIZE 14
#define SUB_TITLE_LABEL_FONT [Utils helveticaNueueFontWithSize:14]

#define DEEP_BREATHING_INTRO_PAGE1_TEXT @"Deep Breathing is a special way to breathe that helps you relax. When people are stressed, their breathing is often shallow and rapid. Breathing deeply tells the body to relax. It counteracts the stress response. You can combine Deep Breathing with Imagery to feel even more relaxed."

#define DEEP_BREATHING_INTRO_PAGE2_TEXT @"Deep Breathing can reduce tension and stress caused by tinnitus. Using Deep Breathing won't change your tinnitus but it can help you relax. Being relaxed can help you cope with your tinnitus."

#define DEEP_BREATHING_INTRO_PAGE3_TEXT @"A video is included with instructions on how to do Deep Breathing. After you watch the video, a timer is provided to help you practice on your own."

#define USING_SOUND_INTRO_PAGE_1 @"Using Sound will guide you to find sounds that can help when your tinnitus is bothering you. You will learn to:\n\n•    Brainstorm ideas for sounds that will\n     help\n•    Make a plan for trying specific sounds\n•    Use the plan when your tinnitus is\n     bothersome\n•    Pay attention to how sounds make you\n     feel\n•    Change your plan as you learn which\n     sounds are helpful and which are not"

#define USING_SOUND_INTRO_PAGE_TITLE_1 @"What is \"Using Sound\"?"

#define G_M_INTRO_PAGE_2 @"What will I be doing in these exercises?" description:@"For three of these exercises you will focus on relaxing different parts of the body where you feel stress. The other two exercises focus on \"mindfulness\". Mindfulness means paying attention to the present moment."

#define P_A_PAGE1_TITLE @"What are \"Pleasant Activities\"?"
#define P_A_PAGE3_TITLE @"What are \"values\"?"
#define P_A_INTRO_PAGE2 @"Some people who are bothered by tinnitus start spending less time doing things they enjoy. This can make a tinnitus problem feel even worse. Adding pleasant activities can help. Activities you enjoy can distract you from your tinnitus. They can also help you feel happier and more relaxed."

#define P_A_INTRO_PAGE3 @"\"Values\" are what is important to you. If you pick activities that fit with your values, you may feel like they add meaning to your life. With this skill you will choose pleasant activities that fit with your values. You will then schedule these activities on your calendar."