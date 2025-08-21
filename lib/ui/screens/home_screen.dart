import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers.dart';
import '../../data/constants.dart';
import '../../data/models.dart';
import '../../data/character_models.dart';
import '../../util/formatters.dart';
import '../../util/responsive_helper.dart';
import '../../theme/app_theme.dart';
import 'advanced_banking_screen.dart';
import '../widgets/market_table_ultra_clean.dart';
import '../widgets/heat_gauge.dart';
import '../widgets/event_feed.dart';
import '../widgets/inventory_drawer.dart';
import '../widgets/upgrades_modal.dart';
import '../widgets/court_modals.dart';
import '../widgets/confirm_end_day.dart';
import '../widgets/goal_progress_pill.dart';
import '../widgets/statistics_dashboard.dart';
import '../widgets/random_event_dialog.dart';
import '../widgets/weapons_shop.dart';
import '../widgets/prison_operations.dart';
import '../widgets/interstate_operations.dart';
import '../widgets/gang_warfare.dart';
import '../widgets/assets_management_new.dart';
import '../widgets/bribery_corruption_new.dart';
import '../widgets/combat_heist_new.dart';
import '../widgets/contracts_board.dart';
import '../widgets/federal_meter_widget.dart';
import '../widgets/crew_loyalty_widget.dart';
import '../widgets/territory_control_widget.dart';
import '../widgets/prestige_system_widget.dart';
import '../widgets/transaction_history_widget.dart';
import '../widgets/lawyer_system_widget.dart';
import '../widgets/character_avatar_widget.dart';
import '../widgets/energy_pill.dart';
import '../widgets/crime_sheet.dart';
import '../widgets/activity_log_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 14, vsync: this); // Updated to include lawyer system
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDisclaimerIfNeeded();
      _checkForPendingEvents();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showDisclaimerIfNeeded() {
    final showDisclaimer = ref.read(gameControllerProvider).settings['showDisclaimer'] ?? true;
    
    if (showDisclaimer) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('⚠️ Important Notice'),
          content: const SingleChildScrollView(
            child: Text(CONTENT_DISCLAIMER),
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(gameControllerProvider.notifier).updateSettings({
                  'showDisclaimer': false,
                });
                Navigator.of(context).pop();
              },
              child: const Text('I Understand'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    final enforcementCase = ref.watch(enforcementCaseProvider);
    
    // Show court modal if there's an active case
    if (enforcementCase != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CourtModals.showArrestModal(context, ref);
      });
    }

    return Scaffold(
      drawer: _buildAdvancedFeaturesDrawer(),
      appBar: AppBar(
        title: Row(
          children: [
            // Character Avatar
            if (gameState.character != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CharacterAvatarWidget(
                  character: gameState.character!,
                  size: 40,
                  showBorder: true,
                ),
              ),
            // Title and character info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Street Tycoon'),
                  if (gameState.character != null)
                    Text(
                      '${gameState.character!.fullName} ${gameState.character!.gender.emoji}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'new_game':
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('New Game'),
                      content: const Text('Save current game and create a new character?\n\nYour current progress will be saved.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('New Game'),
                        ),
                      ],
                    ),
                  );
                  
                  if (confirmed == true && mounted) {
                    await ref.read(gameControllerProvider.notifier).newGameFromMenu();
                    if (mounted) context.go('/save-selection');
                  }
                  break;
                case 'load_game':
                  context.go('/save-selection');
                  break;
                case 'settings':
                  context.push('/settings');
                  break;
                case 'advanced':
                  Scaffold.of(context).openDrawer();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'new_game',
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('New Game'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'load_game',
                child: Row(
                  children: [
                    Icon(Icons.folder_open),
                    SizedBox(width: 8),
                    Text('Load Game'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'advanced',
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Advanced Features'),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.menu),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: AREAS.map((area) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(area),
                          selected: gameState.area == area,
                          onSelected: (_) => ref.read(gameControllerProvider.notifier).travel(area),
                        ),
                      )).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text('Day ${gameState.day}/${gameState.daysLimit}'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Status row (always visible)
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: GoalProgressPill(gameState: gameState)),
                const SizedBox(width: 12),
                EnergyPill(currentEnergy: gameState.energy),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  height: 60,
                  child: HeatGauge(heat: gameState.heat),
                ),
              ],
            ),
          ),
          
          // Tab bar - Make it scrollable for mobile
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(icon: Icon(Icons.store), text: 'Market'),
              Tab(icon: Icon(Icons.assignment), text: 'Contracts'),
              Tab(icon: Icon(Icons.security), text: 'Arsenal'),
              Tab(icon: Icon(Icons.account_balance), text: 'Federal Heat'),
              Tab(icon: Icon(Icons.people), text: 'Crew'),
              Tab(icon: Icon(Icons.location_city), text: 'Territory'),
              Tab(icon: Icon(Icons.stars), text: 'Prestige'),
              Tab(icon: Icon(Icons.gavel), text: 'Legal'),
              Tab(icon: Icon(Icons.home_work), text: 'Prison'),
              Tab(icon: Icon(Icons.map), text: 'Interstate'),
              Tab(icon: Icon(Icons.group), text: 'Gang Wars'),
              Tab(icon: Icon(Icons.directions_car), text: 'Assets'),
              Tab(icon: Icon(Icons.monetization_on), text: 'Corruption'),
              Tab(icon: Icon(Icons.local_fire_department), text: 'Combat'),
            ],
          ),
          
          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Market Tab
                _buildMarketTab(gameState),
                
                // Contracts Tab
                const ContractsBoard(),
                
                // Arsenal Tab (Weapons)
                const WeaponsShop(),
                
                // Federal Tab (Federal Heat Meter)
                const FederalMeterWidget(),
                
                // Crew Tab (Crew & Loyalty Management)
                const CrewLoyaltyWidget(),
                
                // Territory Tab (Territory Control)
                const TerritoryControlWidget(),
                
                // Prestige Tab (Prestige System)
                const PrestigeSystemWidget(),
                
                // Legal Tab (Lawyer System)
                const LawyerSystemWidget(),
                
                // Prison Tab (Operations)
                const PrisonOperationsWidget(),
                
                // Interstate Tab (Multi-state Operations)
                const InterstateOperationsWidget(),
                
                // Gang Wars Tab (Gang Warfare & Territory Control)
                GangWarfareWidget(),
                
                // Assets Tab (Vehicles, Properties, Luxury Items)
                const AssetsManagementWidget(),
                
                // Corruption Tab (Bribery & Official Corruption)
                const BriberyCorruptionWidget(),
                
                // Combat Tab (Heists & Combat Operations)
                const CombatHeistWidget(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Advanced Features Quick Access
          FloatingActionButton(
            heroTag: "advanced",
            mini: true,
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Advanced Features',
            child: const Icon(Icons.auto_awesome),
          ),
          const SizedBox(height: 8),
          // Statistics Dashboard
          FloatingActionButton.extended(
            heroTag: "stats",
            onPressed: () => _showStatisticsDashboard(),
            icon: const Icon(Icons.analytics),
            label: const Text('Stats'),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketTab(GameState gameState) {
    return Column(
      children: [
        // Market table
        const Expanded(
          flex: 3,
          child: MarketTable(),
        ),
        
        // Transaction History
        const Expanded(
          flex: 2,
          child: TransactionHistoryWidget(),
        ),
        
        // Action buttons - Made scrollable and more compact for mobile
        Container(
          height: 120, // Fixed height to prevent overflow
          padding: const EdgeInsets.all(12), // Reduced padding
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showInventoryDrawer(),
                        icon: const Icon(Icons.inventory, size: 18),
                        label: Text(
                          'Inventory (${gameState.usedCapacity}/${gameState.capacity})',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToAdvancedBanking(),
                        icon: const Icon(Icons.account_balance, size: 18),
                        label: Text(
                          'Bank (\$${Formatters.money(gameState.bank)})',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showUpgradesModal(),
                        icon: const Icon(Icons.upgrade, size: 18),
                        label: const Text('Upgrades', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: gameState.cash >= 40 ? () => ref.read(gameControllerProvider.notifier).layLow() : null,
                        icon: const Icon(Icons.spa, size: 18),
                        label: const Text('Lay Low', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showCrimesSheet(),
                        icon: const Icon(Icons.warning, size: 18),
                        label: const Text('Crimes', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade800,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showActivityLog(),
                        icon: const Icon(Icons.history, size: 18),
                        label: const Text('Activity Log', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _showEndDayConfirmation(),
                        icon: const Icon(Icons.bedtime, size: 18),
                        label: const Text('End Day', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Event feed
        const Expanded(
          flex: 1,
          child: EventFeed(),
        ),
      ],
    );
  }

  void _showInventoryDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => InventoryDrawer(
          scrollController: scrollController,
        ),
      ),
    );
  }

  void _navigateToAdvancedBanking() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AdvancedBankingScreen(),
      ),
    );
  }

  void _showCustomDepositDialog() {
    final gameState = ref.read(gameControllerProvider);
    final TextEditingController amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('💰 Custom Deposit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Available Cash: \$${Formatters.money(gameState.cash)}'),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount to deposit',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(amountController.text) ?? 0;
              if (amount > 0 && amount <= gameState.cash) {
                ref.read(gameControllerProvider.notifier).deposit(amount);
                Navigator.pop(context);
              }
            },
            child: const Text('Deposit'),
          ),
        ],
      ),
    );
  }

  void _showCustomWithdrawDialog() {
    final gameState = ref.read(gameControllerProvider);
    final TextEditingController amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🏦 Custom Withdraw'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Available in Bank: \$${Formatters.money(gameState.bank)}'),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount to withdraw',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(amountController.text) ?? 0;
              if (amount > 0 && amount <= gameState.bank) {
                ref.read(gameControllerProvider.notifier).withdraw(amount);
                Navigator.pop(context);
              }
            },
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }

  void _showUpgradesModal() {
    showDialog(
      context: context,
      builder: (context) => const UpgradesModal(),
    );
  }

  void _showCrimesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CrimeSheet(),
    );
  }

  void _showActivityLog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ActivityLogSheet(),
    );
  }

  void _showEndDayConfirmation() {
    showDialog(
      context: context,
      builder: (context) => const ConfirmEndDay(),
    );
  }

  void _showStatisticsDashboard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: const StatisticsDashboard(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkForPendingEvents() {
    final pendingEventId = ref.read(gameControllerProvider).settings['pendingEvent'];
    if (pendingEventId != null) {
      // Clear the pending event
      ref.read(gameControllerProvider.notifier).updateSettings({'pendingEvent': null});
      
      // Show event dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => RandomEventDialog(),
        );
      });
    }
  }

  Widget _buildAdvancedFeaturesDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1a1a1a), Color(0xFF2d2d2d)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.auto_awesome, size: 40, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'Advanced Features',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Access all game systems',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Character Development
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.blue),
            title: const Text('Character Development'),
            subtitle: const Text('Skills, attributes & progression'),
            onTap: () {
              Navigator.pop(context);
              context.push('/character-development');
            },
          ),
          
          // Business Management
          ListTile(
            leading: const Icon(Icons.business_center, color: Colors.green),
            title: const Text('Business Management'),
            subtitle: const Text('Stocks, crypto & legitimate businesses'),
            onTap: () {
              Navigator.pop(context);
              context.push('/business-management');
            },
          ),
          
          // Achievements
          ListTile(
            leading: const Icon(Icons.emoji_events, color: Colors.orange),
            title: const Text('Achievements'),
            subtitle: const Text('Unlock rewards & milestones'),
            onTap: () {
              Navigator.pop(context);
              context.push('/achievements');
            },
          ),
          
          // Action Minigames
          ListTile(
            leading: const Icon(Icons.games, color: Colors.purple),
            title: const Text('Action Minigames'),
            subtitle: const Text('Interactive skill challenges'),
            onTap: () {
              Navigator.pop(context);
              context.push('/minigames');
            },
          ),
          
          // World Map
          ListTile(
            leading: const Icon(Icons.public, color: Colors.teal),
            title: const Text('World Map'),
            subtitle: const Text('Global expansion & operations'),
            onTap: () {
              Navigator.pop(context);
              context.push('/world-map');
            },
          ),
          
          // Legal System (Enhanced)
          ListTile(
            leading: const Icon(Icons.gavel, color: Colors.red),
            title: const Text('Legal System'),
            subtitle: const Text('Advanced court cases & law'),
            onTap: () {
              Navigator.pop(context);
              context.push('/legal-system');
            },
          ),
          
          const Divider(),
          
          // Quick Stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer(
              builder: (context, ref, child) {
                final gameState = ref.watch(gameControllerProvider);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Stats',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('💰 Cash: \$${Formatters.money(gameState.cash)}'),
                    Text('📊 Heat: ${gameState.heat.toInt()}%'),
                    Text('📅 Day: ${gameState.day}/${gameState.daysLimit}'),
                    Text('� Area: ${gameState.area}'),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
