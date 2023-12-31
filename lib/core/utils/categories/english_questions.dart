import 'dart:math';

class EnglishCategories{

  static const List<String> _categories = [
    "A Boy's Name",
    "U.S. Cities",
    "Things That Are Cold",
    "School Supplies",
    "Pro Sports Teams",
    "Insects",
    "Breakfast Foods",
    "A girl’s name",
    "A boy’s name",
    "Capital cities",
    "Countries",
    "Animals",
    "Musical Instruments",
    "Flowers",
    "Gemstones",
    "Cartoon Characters",
    "Four letter words",
    "Brands",
    "Things on a beach",
    "Websites",
    "Cars",
    "Things that are sticky",
    "Things that you shout",
    "Excuses for being late",
    "Pet peeves",
    "Ice cream flavors",
    "Fried foods",
    "Bodies of water",
    "Halloween costumes",
    "Places to go on a date",
    "Nicknames",
    "Job titles",
    "College majors",
    "Languages",
    "Historical figures",
    "Celebrities",
    "Holidays",
    "Items in a gift shop",
    "Relatives",
    "Things in an office",
    "Software",
    "Fears",
    "Apps",
    "Electronic devices",
    "Movie titles",
    "Book titles",
    "Pets",
    "Musical instruments",
    "Types of music",
    "Aquatic animals",
    "Animals in a zoo",
    "Things you get in the mail",
    "Song title",
    "Vacation destination",
    "Famous animals",
    "Drinks",
    "Hobbies",
    "Things in space",
    "Types of candy",
    "Ways to get from here to there",
    "Furniture",
    "Plants",
    "Things in a museum",
    "Sports teams",
    "Extreme sports",
    "Colors",
    "Tools",
    "Dangerous activities",
    "Things you might go viral for",
    "Item within eyesight",
    "Things that are blue",
    "Body parts",
    "Expensive items",
    "Snack foods",
    "Healthy foods",
    "Animals in a zoo",
    "Something people hate doing",
    "Something that surprises you",
    "A common lie",
    "Something to strive for",
    "Awards/ceremonies",
    "Fireable offenses",
    "Random acts of kindness",
    "Four letter word (in a foreign language)",
    "TV shows",
    "Crimes",
    "Office supplies",
    "Things on your work desk",
    "Things associated with Xmas",
    "Game shows",
    "Board games",
    "Video games",
    "Superheroes",
    "Pizza toppings",
    "World cuisine",
    "Things that make you laugh",
    "Something you keep secret",
    "Things you say at work",
    "Mythical creatures",
    "“Adulting” activities",
    "Topics you like to talk about",
    "Breakfast foods",
    "Annoying movie tropes",
    "Things you see on a road trip",
    "Things you see in the news",
    "Things you find in nature",
    "Things in the sky",
    "Things on people’s bucket lists",
    "Things in an airport",
    "Villains",
    "Four syllable words",
    "Words with two meanings",
    "Good qualities for a friend",
    "Guilty pleasures",
    "Clothing",
    "Words associated with self-care",
    "Art projects",
    "Weather",
    "Things associated with summer",
    "Musicals",
    "Things you look forward to",
    "Presidents",
    "Furniture",
    "T.V. Shows",
    "Things That Are Found in the Ocean",
    "Presidents",
    "Product Names",
    "Appliances",
    "Types of Drink",
    "Personality Traits",
    "Articles of Clothing",
    "Desserts",
    "Car Parts",
    "Athletes",
    "3-Letter Words",
    "Items in a Refrigerator",
    "Farm Animals",
    "Street Names",
    "Things on a Beach",
    "Colors",
    "Tools",
    "A Girl's Name",
    "Villains/Monsters",
    "Footwear",
    "Something You're Afraid Of",
    "Terms of Measurement",
    "Book Titles",
    "Heroes",
    "Gifts/Presents",
    "Kinds of Dances",
    "Things That Are Black",
    "Vehicles",
    "Tropical Locations",
    "College Majors",
    "Dairy Products",
    "Things in a Souvenir Shop",
    "Items in Your Purse/Wallet",
    "Famous Females",
    "Medicine/Drugs",
    "Things Made of Metal",
    "Hobbies",
    "People in Uniform",
    "Things You Plug In",
    "Animals",
    "Languages",
    "Names Used in the Bible",
    "Junk Food",
    "Things That Grow",
    "Companies",
    "Video Games",
    "Electronic Gadgets",
    "Board Games",
    "Things That Use a Remote",
    "Card Games",
    "Internet Lingo",
    "Offensive Words",
    "Wireless Things",
    "Computer Parts",
    "Software",
    "Websites",
    "Game Terms",
    "Things in a Grocery Store",
    "Reasons to Quit Your Job",
    "Things That Have Stripes",
    "Tourist Attractions",
    "Diet Foods",
    "Things Found in a Hospital",
    "Food/Drink That Is Green",
    "Weekend Activities",
    "Acronyms",
    "Seafood",
    "Christmas Songs",
    "Words Ending in -N",
    "Words With Double Letters",
    "Childrens Books",
    "Things Found at a Bar",
    "Sports Played Indoors",
    "Names Used in Songs",
    "Foods You Eat Raw",
    "Places in Europe",
    "Olympic Events",
    "Things You See at the Zoo",
    "Math Terms",
    "Animals in Books or Movies",
    "Things to Do at a Party",
    "Sandwiches",
    "Items in a Catalog",
    "World Leaders/Politicians",
    "School Subjects",
    "Excuses for Being Late",
    "Ice Cream Flavors",
    "Things That Jump/Bounce",
    "Television Stars",
    "Things in a Park",
    "Foreign Cities",
    "Stones/Gems",
    "Musical Instruments",
    "Nicknames",
    "Things in the Sky",
    "Pizza Toppings",
    "Colleges/Universities",
    "Fish",
    "Countries",
    "Things That Have Spots",
    "Historical Figures",
    "Terms of Endearment",
    "Items in This Room",
    "Fictional Characters",
    "Menu Items",
    "Magazines",
    "Capitals",
    "Kinds of Candy",
    "Items You Save Up to Buy",
    "Footware",
    "Something You Keep Hidden",
    "Items in a Suitcase",
    "Things With Tails",
    "Sports Equipment",
    "Crimes",
    "Things That Are Sticky",
    "Awards/Ceremonies",
    "Cars",
    "Spices/Herbs",
    "Bad Habits",
    "Cosmetics/Toiletries",
    "Celebrities",
    "Cooking Utensils",
    "Reptiles/Amphibians",
    "Parks",
    "Leisure Activities",
    "Things You're Allergic To",
    "Restaurants",
    "Notorious People",
    "Fruits",
    "Things in a Medicine Cabinet",
    "Toys",
    "Household Chores",
    "Bodies of Water",
    "Authors",
    "Halloween Costumes",
    "Weapons",
    "Things That Are Round",
    "Words Associated With Exercise",
    "Sports",
    "Song Titles",
    "Parts of the Body",
    "Ethnic Foods",
    "Things You Shout",
    "Birds",
    "Methods of Transportation",
    "Items in a Kitchen",
    "Flowers",
    "Things You Replace",
    "Famous Duos and Trios",
    "Things Found in a Desk",
    "Vacation Spots",
    "Diseases",
    "Words Associated With Money",
    "Items in a Vending Machine",
    "Movie Titles",
    "Games",
    "Things That You Wear",
    "Beers",
    "Things at a Circus",
    "Vegetables",
    "States",
    "Things You Throw Away",
    "Occupations",
    "Cartoon Characters",
    "Types of Drinks",
    "Musical Groups",
    "Store Names",
    "Things at a Football Game",
    "Trees",
    "Kinds of Soup",
    "Things Found in New York",
    "Things You Get Tickets For",
    "Things You Do at Work",
    "Foreign Words Used in English",
    "Things You Shouldn't Touch",
    "Spicy Foods",
    "Things at a Carnival",
    "Things You Make",
    "Places to Hang Out",
    "Computer Programs",
    "Honeymoon Spots",
    "Things You Buy for Kids",
    "Things That Can Kill You",
    "Reasons to Take Out a Loan",
    "Words Associated With Winter",
    "Things to Do on a Date",
    "Historic Events",
    "Things You Store Items In",
    "Things You Do Every Day",
    "Things You Get in the Mail",
    "Things You Save Up to Buy",
    "Things You Sit In/On",
    "Reasons to Make a Phone Call",
    "Types of Weather",
    "Titles People Can Have",
    "Things That Have Buttons",
    "Items You Take on a Trip",
    "Things That Have Wheels",
    "Reasons to Call 911",
    "Things That Make You Smile",
    "Ways to Kill Time",
    "Things That Can Get You Fired",
    "Holiday Activities"
  ];

  static List<String> get categories => List.from(_categories);

  static void addCategory(String newCategory) {
    _categories.add(newCategory);
  }
  static List<String> getRandomCategories({required int number}) {
    final random = Random();
    final List<String> randomCategories = [];

    while (randomCategories.length < number) {
      final int randomIndex = random.nextInt(_categories.length);
      final String randomCategory = _categories[randomIndex];

      if (!randomCategories.contains(randomCategory)) {
        randomCategories.add(randomCategory);
      }
    }

    return randomCategories;
  }

}

