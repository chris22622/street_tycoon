// Areas with price modifiers
const List<String> AREAS = [
  'Downtown',
  'Riverside', 
  'Old Town',
  'Harbor',
  'Uptown',
];

const Map<String, double> AREA_MODIFIERS = {
  'Downtown': 1.00,
  'Riverside': 0.92,
  'Old Town': 1.08,
  'Harbor': 0.96,
  'Uptown': 1.15,
};

// Fictional drug names (names only, no real pricing/strategy)
const List<String> GOODS = [
  'Heroin',
  'Cocaine (Powder)',
  'Crack Cocaine',
  'Methamphetamine',
  'MDMA (Ecstasy)',
  'LSD (Acid)',
  'Psilocybin Mushrooms',
  'Cannabis (Marijuana)',
  'Hashish',
  'Fentanyl',
  'Oxycodone',
  'Hydrocodone',
  'Morphine',
  'Ketamine',
  'GHB',
  'PCP',
  'DMT',
  'Amphetamine (Adderall)',
  'Alprazolam (Xanax)',
  'Diazepam (Valium)',
  'Codeine Syrup',
  'Synthetic Cannabinoids (K2/Spice)',
  'Synthetic Cathinones (Bath Salts)',
  'Nitrous Oxide',
  'Tramadol',
];

// Base prices (fictional, for entertainment only)
const Map<String, int> BASE_PRICES = {
  'Heroin': 120,
  'Cocaine (Powder)': 180,
  'Crack Cocaine': 85,
  'Methamphetamine': 95,
  'MDMA (Ecstasy)': 45,
  'LSD (Acid)': 15,
  'Psilocybin Mushrooms': 30,
  'Cannabis (Marijuana)': 25,
  'Hashish': 35,
  'Fentanyl': 90,
  'Oxycodone': 60,
  'Hydrocodone': 55,
  'Morphine': 70,
  'Ketamine': 80,
  'GHB': 40,
  'PCP': 65,
  'DMT': 150,
  'Amphetamine (Adderall)': 20,
  'Alprazolam (Xanax)': 10,
  'Diazepam (Valium)': 8,
  'Codeine Syrup': 50,
  'Synthetic Cannabinoids (K2/Spice)': 15,
  'Synthetic Cathinones (Bath Salts)': 25,
  'Nitrous Oxide': 5,
  'Tramadol': 12,
};

// Game constants
const int INITIAL_CASH = 1000;
const int INITIAL_BANK = 0;
const int INITIAL_CAPACITY = 40;
const int INITIAL_HEAT = 0;
const int INITIAL_DAYS_LIMIT = 30;
const int INITIAL_GOAL_NET_WORTH = 50000;
const String INITIAL_AREA = 'Downtown';

// Heat and enforcement constants
const double BASE_ENFORCEMENT_PROB = 0.05;
const double HEAT_ENFORCEMENT_MULTIPLIER = 0.004;
const double BIG_MOVES_ENFORCEMENT_BONUS = 0.02;
const double MAX_ENFORCEMENT_PROB = 0.45;

// Upgrade costs and effects
const int DUFFEL_BASE_COST = 150;
const int DUFFEL_COST_MULTIPLIER = 100;
const int DUFFEL_CAPACITY_BONUS = 10;

const int SAFEHOUSE_BASE_COST = 220;
const int SAFEHOUSE_COST_MULTIPLIER = 140;

const int LAWYER_BASE_COST = 300;
const int LAWYER_COST_MULTIPLIER = 180;

// Energy System
const int kEnergyMax = 100;
const int kEnergyEndDayThreshold = 0;
const int kEnergyBaseRegenNightly = 25; // + 10 per Safehouse level
const int kEnergyBuy = 1;
const int kEnergySell = 1;
const int kEnergyTravel = 4;
const int kEnergyLayLow = 2;

// Crime System (fictional)
const double kCrimeBaseArrestBump = 0.03;   // added to enforcement odds when a crime is attempted
const double kCrimeFailHeat = 6;            // heat added on failed crime
const double kCrimeSuccessHeat = 2;         // small heat even on success

// Other constants
const int TRAVEL_COST = 5;
const int LAY_LOW_BASE_COST = 40;
const int LAY_LOW_COST_PER_HEAT = 5;
const int LAY_LOW_HEAT_REDUCTION = 12;
const double BANK_DAILY_INTEREST = 0.001;

// Event probabilities
const double RANDOM_EVENT_PROBABILITY = 0.3;

// Content disclaimer
const String CONTENT_DISCLAIMER = '''
⚠️ FICTIONAL SIMULATION DISCLAIMER ⚠️

This app is a fictional simulation for entertainment purposes only. All names, prices, events, and mechanics are completely invented and bear no relation to reality.

DO NOT use this app for real-world guidance of any kind. This is a game, not reality.

All content is fictional and for entertainment only.
''';
