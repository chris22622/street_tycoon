import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers.dart';
import '../../data/constants.dart';
import '../../data/models.dart';
import '../../util/formatters.dart';
import '../widgets/market_table.dart';
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
import '../widgets/federal_investigations.dart';
import '../widgets/prison_operations.dart';
import '../widgets/interstate_operations.dart';
import '../widgets/gang_warfare.dart';
import '../widgets/assets_management_new.dart';
import '../widgets/bribery_corruption_new.dart';
import '../widgets/combat_heist_new.dart';

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
    _tabController = TabController(length: 9, vsync: this); // Updated to include all new systems
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
      appBar: AppBar(
        title: const Text('Street Tycoon'),
        actions: [
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings),
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
                const SizedBox(width: 16),
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
              Tab(icon: Icon(Icons.security), text: 'Arsenal'),
              Tab(icon: Icon(Icons.account_balance), text: 'Federal'),
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
                
                // Arsenal Tab (Weapons)
                const WeaponsShop(),
                
                // Federal Tab (Investigations)
                const FederalInvestigationsWidget(),
                
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showStatisticsDashboard(),
        icon: const Icon(Icons.analytics),
        label: const Text('Stats'),
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
                        onPressed: () => _showBankModal(),
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
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _showEndDayConfirmation(),
                    icon: const Icon(Icons.bedtime, size: 18),
                    label: const Text('End Day', style: TextStyle(fontSize: 12)),
                  ),
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

  void _showBankModal() {
    final gameState = ref.read(gameControllerProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🏦 Bank Operations'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('💰 Cash: \$${Formatters.money(gameState.cash)}'),
            Text('🏦 Bank: \$${Formatters.money(gameState.bank)}'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: gameState.cash >= 1000 ? () {
                      ref.read(gameControllerProvider.notifier).deposit(1000);
                      Navigator.pop(context);
                    } : null,
                    child: const Text('Deposit \$1,000'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: gameState.bank >= 1000 ? () {
                      ref.read(gameControllerProvider.notifier).withdraw(1000);
                      Navigator.pop(context);
                    } : null,
                    child: const Text('Withdraw \$1,000'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: gameState.cash >= 5000 ? () {
                      ref.read(gameControllerProvider.notifier).deposit(5000);
                      Navigator.pop(context);
                    } : null,
                    child: const Text('Deposit \$5,000'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: gameState.bank >= 5000 ? () {
                      ref.read(gameControllerProvider.notifier).withdraw(5000);
                      Navigator.pop(context);
                    } : null,
                    child: const Text('Withdraw \$5,000'),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
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
}
