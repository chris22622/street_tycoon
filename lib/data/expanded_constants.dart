// Expanded Constants for Advanced Features
import 'world_models.dart';
import 'customization_models.dart';

// World Building Constants
const List<City> CITIES = [
  City(
    id: 'chicago',
    name: 'Chicago',
    country: 'USA',
    districts: ['Downtown', 'Riverside', 'Old Town', 'Harbor', 'Uptown'],
    economicModifiers: {'base_cost': 1.0, 'profit_margin': 1.0},
    riskModifiers: {'police_presence': 1.0, 'gang_activity': 1.0},
    availableGoods: ['Heroin', 'Cocaine (Powder)', 'Cannabis (Marijuana)', 'MDMA (Ecstasy)'],
    description: 'Your starting city with moderate risk and reward.',
    isUnlocked: true,
    unlockCost: 0,
  ),
  City(
    id: 'nyc',
    name: 'New York City',
    country: 'USA',
    districts: ['Manhattan', 'Brooklyn', 'Bronx', 'Queens', 'Staten Island'],
    economicModifiers: {'base_cost': 1.5, 'profit_margin': 1.8},
    riskModifiers: {'police_presence': 1.7, 'gang_activity': 1.4},
    availableGoods: ['Heroin', 'Cocaine (Powder)', 'Crack Cocaine', 'Fentanyl', 'MDMA (Ecstasy)'],
    description: 'High-stakes market with massive profits but extreme law enforcement.',
    unlockCost: 500000,
  ),
  City(
    id: 'miami',
    name: 'Miami',
    country: 'USA',
    districts: ['South Beach', 'Downtown', 'Little Havana', 'Wynwood', 'Coconut Grove'],
    economicModifiers: {'base_cost': 1.3, 'profit_margin': 1.6},
    riskModifiers: {'police_presence': 1.2, 'gang_activity': 1.8},
    availableGoods: ['Cocaine (Powder)', 'MDMA (Ecstasy)', 'Cannabis (Marijuana)', 'Methamphetamine'],
    description: 'Gateway for international operations with high gang activity.',
    unlockCost: 300000,
  ),
  City(
    id: 'la',
    name: 'Los Angeles',
    country: 'USA',
    districts: ['Hollywood', 'Downtown', 'Venice', 'Beverly Hills', 'Compton'],
    economicModifiers: {'base_cost': 1.4, 'profit_margin': 1.5},
    riskModifiers: {'police_presence': 1.3, 'gang_activity': 1.6},
    availableGoods: ['Methamphetamine', 'Cannabis (Marijuana)', 'Cocaine (Powder)', 'LSD (Acid)'],
    description: 'Entertainment capital with diverse markets and celebrity clientele.',
    unlockCost: 400000,
  ),
  City(
    id: 'vegas',
    name: 'Las Vegas',
    country: 'USA',
    districts: ['The Strip', 'Downtown', 'Henderson', 'Summerlin', 'North Las Vegas'],
    economicModifiers: {'base_cost': 1.2, 'profit_margin': 1.7},
    riskModifiers: {'police_presence': 0.9, 'gang_activity': 1.2},
    availableGoods: ['Cocaine (Powder)', 'MDMA (Ecstasy)', 'Cannabis (Marijuana)', 'Alprazolam (Xanax)'],
    description: 'Sin City with loose regulations and high-roller clients.',
    unlockCost: 250000,
  ),
  City(
    id: 'colombia',
    name: 'Medellín',
    country: 'Colombia',
    districts: ['El Poblado', 'Laureles', 'Envigado', 'Comuna 13', 'Bello'],
    economicModifiers: {'base_cost': 0.3, 'profit_margin': 0.4},
    riskModifiers: {'police_presence': 0.7, 'gang_activity': 2.5},
    availableGoods: ['Cocaine (Powder)', 'Heroin', 'Cannabis (Marijuana)'],
    description: 'Source operations with extremely low costs but high violence risk.',
    unlockCost: 1000000,
  ),
  City(
    id: 'mexico',
    name: 'Tijuana',
    country: 'Mexico',
    districts: ['Zona Centro', 'Playas', 'Otay', 'La Mesa', 'Sanchez Taboada'],
    economicModifiers: {'base_cost': 0.5, 'profit_margin': 0.6},
    riskModifiers: {'police_presence': 0.8, 'gang_activity': 2.0},
    availableGoods: ['Methamphetamine', 'Heroin', 'Fentanyl', 'Cocaine (Powder)'],
    description: 'Border operations with cartel connections and smuggling routes.',
    unlockCost: 750000,
  ),
];

const List<TimePeriod> TIME_PERIODS = [
  TimePeriod(
    id: '1980s',
    name: '1980s - Crack Epidemic',
    startYear: 1980,
    endYear: 1989,
    priceModifiers: {'Crack Cocaine': 0.3, 'Cocaine (Powder)': 2.0, 'Heroin': 1.5},
    availableTechnology: ['pager', 'payphone', 'cash_only'],
    events: [],
    description: 'The rise of crack cocaine and massive cocaine profits.',
    isUnlocked: true,
  ),
  TimePeriod(
    id: '1990s',
    name: '1990s - War on Drugs',
    startYear: 1990,
    endYear: 1999,
    priceModifiers: {'all': 1.2}, // Increased enforcement drives up prices
    availableTechnology: ['cellular_phone', 'beeper', 'early_internet'],
    events: [],
    description: 'Increased law enforcement and the beginning of modern drug war.',
  ),
  TimePeriod(
    id: '2000s',
    name: '2000s - Prescription Crisis',
    startYear: 2000,
    endYear: 2009,
    priceModifiers: {'Oxycodone': 0.4, 'Hydrocodone': 0.4, 'MDMA (Ecstasy)': 1.8},
    availableTechnology: ['internet', 'cell_phone', 'gps'],
    events: [],
    description: 'Rise of prescription drug abuse and party drugs.',
  ),
];

// Character Development Constants
const List<String> SKILL_CATEGORIES = [
  'Criminal',
  'Business', 
  'Social',
  'Technical',
  'Physical',
  'Mental',
];

const Map<String, List<String>> SKILLS_BY_CATEGORY = {
  'Criminal': [
    'Drug Manufacturing',
    'Money Laundering',
    'Intimidation',
    'Smuggling',
    'Security Bypass',
    'Evidence Disposal',
  ],
  'Business': [
    'Market Analysis',
    'Investment Strategy',
    'Negotiation',
    'Supply Chain Management',
    'Quality Control',
    'Risk Assessment',
  ],
  'Social': [
    'Reputation Management',
    'Network Building',
    'Corruption',
    'Public Relations',
    'Community Relations',
    'Political Influence',
  ],
  'Technical': [
    'Cybersecurity',
    'Surveillance',
    'Communications',
    'Financial Technology',
    'Laboratory Management',
    'Logistics Optimization',
  ],
  'Physical': [
    'Combat Training',
    'Stealth Operations',
    'Driving Skills',
    'Weapons Proficiency',
    'Escape Techniques',
    'Physical Fitness',
  ],
  'Mental': [
    'Strategic Planning',
    'Psychological Warfare',
    'Stress Management',
    'Learning Ability',
    'Memory Enhancement',
    'Decision Making',
  ],
};

// Business Features Constants
const List<String> LEGITIMATE_BUSINESS_TYPES = [
  'Restaurant',
  'Car Wash',
  'Nightclub',
  'Construction Company',
  'Import/Export',
  'Real Estate',
  'Security Firm',
  'Entertainment Venue',
  'Tech Startup',
  'Consulting Firm',
];

const List<String> STOCK_SYMBOLS = [
  'AAPL', 'GOOGL', 'MSFT', 'AMZN', 'TSLA',
  'META', 'NFLX', 'NVDA', 'AMD', 'INTC',
  'JPM', 'BAC', 'WFC', 'GS', 'MS',
  'XOM', 'CVX', 'COP', 'BP', 'SHEL',
];

const List<String> CRYPTOCURRENCY_SYMBOLS = [
  'BTC', 'ETH', 'BNB', 'XRP', 'ADA',
  'SOL', 'DOT', 'DOGE', 'AVAX', 'SHIB',
  'MATIC', 'LTC', 'UNI', 'LINK', 'BCH',
];

// Legal System Constants
const List<String> LAWYER_SPECIALTIES = [
  'Criminal Defense',
  'Corporate Law',
  'International Law',
  'Tax Law',
  'Constitutional Law',
  'Immigration Law',
];

const List<String> COURT_TYPES = [
  'Municipal Court',
  'State Court',
  'Federal Court',
  'Appeals Court',
  'Supreme Court',
  'International Court',
];

// Action Elements Constants
const List<String> MINIGAME_TYPES = [
  'Shootout',
  'Car Chase',
  'Stealth Mission',
  'Negotiation',
  'Hacking',
  'Demolition',
  'Surveillance',
];

// Achievement Categories
const List<String> ACHIEVEMENT_CATEGORIES = [
  'First Steps',
  'Business Milestones',
  'Criminal Achievements',
  'Social Impact',
  'Technical Mastery',
  'Survival Challenges',
  'Hidden Secrets',
  'Community Challenges',
];

// UI Themes
const List<UITheme> AVAILABLE_THEMES = [
  UITheme(
    id: 'neon_80s',
    name: '80s Neon',
    style: '80s_neon',
    colors: {
      'primary': '#FF00FF',
      'secondary': '#00FFFF',
      'background': '#000000',
      'accent': '#FFFF00',
    },
    fonts: {'main': 'Orbitron', 'accent': 'Audiowide'},
    animations: {'glow': 1.0, 'pulse': 1.0},
    soundEffects: ['synthwave', 'retro_beep'],
    isUnlocked: true,
  ),
  UITheme(
    id: 'modern_dark',
    name: 'Modern Dark',
    style: 'modern_dark',
    colors: {
      'primary': '#007ACC',
      'secondary': '#FF6B35',
      'background': '#1E1E1E',
      'accent': '#4CAF50',
    },
    fonts: {'main': 'Roboto', 'accent': 'Roboto Condensed'},
    animations: {'slide': 1.0, 'fade': 1.0},
    soundEffects: ['modern_click', 'success_chime'],
    isUnlocked: true,
  ),
  UITheme(
    id: 'classic',
    name: 'Classic',
    style: 'classic',
    colors: {
      'primary': '#4A90E2',
      'secondary': '#7ED321',
      'background': '#F5F5F5',
      'accent': '#D0021B',
    },
    fonts: {'main': 'Arial', 'accent': 'Times New Roman'},
    animations: {'none': 0.0},
    soundEffects: ['classic_beep'],
    isUnlocked: true,
  ),
];

// Seasonal Events
const Map<String, List<String>> SEASONAL_EVENTS = {
  'Spring': ['Spring Festival', 'Tax Season Chaos'],
  'Summer': ['Beach Party Sales', 'Festival Circuit'],
  'Fall': ['Back to School Rush', 'Halloween Specials'],
  'Winter': ['Holiday Demand Spike', 'New Year Resolutions'],
};

// International Routes
const List<InternationalRoute> SMUGGLING_ROUTES = [
  InternationalRoute(
    id: 'colombia_miami',
    fromCity: 'colombia',
    toCity: 'miami',
    routeType: 'sea',
    riskMultiplier: 1.8,
    profitMultiplier: 4.0,
    requiredAssets: ['boat', 'contacts'],
    cost: 100000,
    duration: 72,
  ),
  InternationalRoute(
    id: 'mexico_la',
    fromCity: 'mexico',
    toCity: 'la',
    routeType: 'land',
    riskMultiplier: 1.5,
    profitMultiplier: 3.0,
    requiredAssets: ['truck', 'tunnel'],
    cost: 75000,
    duration: 24,
  ),
];

// Economic Cycles
const Map<String, Map<String, double>> ECONOMIC_CYCLES = {
  'recession': {
    'demand_multiplier': 0.7,
    'price_volatility': 1.5,
    'law_enforcement_budget': 0.8,
  },
  'growth': {
    'demand_multiplier': 1.3,
    'price_volatility': 0.8,
    'law_enforcement_budget': 1.2,
  },
  'stable': {
    'demand_multiplier': 1.0,
    'price_volatility': 1.0,
    'law_enforcement_budget': 1.0,
  },
};
