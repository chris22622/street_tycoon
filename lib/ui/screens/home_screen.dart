import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers.dart';
import '../../data/models.dart';
import '../../data/constants.dart';
import '../../util/formatters.dart';
import '../widgets/market_table_ultra_clean.dart';
import '../widgets/event_feed.dart';
import '../widgets/contracts_board.dart';
import '../widgets/weapons_shop.dart';
import '../widgets/combat_heist_new.dart';
import '../widgets/prison_operations.dart';
import '../widgets/assets_management_new.dart';
import '../widgets/territory_control_widget.dart';
import '../widgets/interstate_operations.dart';
import '../widgets/prestige_system_widget.dart';
import '../widgets/federal_investigations.dart';
import '../widgets/gang_warfare.dart';
import '../widgets/bribery_corruption_new.dart';
import '../widgets/lawyer_system_widget.dart';
import '../widgets/crew_loyalty_widget.dart';
import '../widgets/goal_progress_pill.dart';
import '../widgets/transaction_history_widget.dart';
import '../widgets/inventory_drawer.dart';
import '../widgets/energy_pill.dart';
import '../widgets/heat_gauge.dart';
import '../widgets/statistics_dashboard.dart';
import '../widgets/activity_log_sheet.dart';
import '../widgets/confirm_end_day.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final gs = ref.watch(gameControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(gs),
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: [
                  _marketPage(gs),
                  _opsPage(),
                  _empirePage(),
                  _crewPage(),
                  _youPage(gs),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (i) => setState(() => _currentTab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.storefront), label: 'Market'),
          NavigationDestination(icon: Icon(Icons.local_fire_department), label: 'Ops'),
          NavigationDestination(icon: Icon(Icons.domain), label: 'Empire'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Crew'),
          NavigationDestination(icon: Icon(Icons.person), label: 'You'),
        ],
      ),
    );
  }

  Widget _buildTopBar(GameState gs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFFFD700),
            child: Text(
              _getInitials(gs),
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(Formatters.moneyShort(gs.cash),
                  style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 16)),
              Text('Day ${gs.day}/${gs.daysLimit}  \u2022  ${gs.area}',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: gs.heat > 60 ? Colors.red.shade900 : gs.heat > 30 ? Colors.orange.shade900 : Colors.green.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.whatshot, size: 14, color: Colors.white),
                const SizedBox(width: 4),
                Text('${gs.heat}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: _handleMenuAction,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'achievements', child: Text('Achievements')),
              PopupMenuItem(value: 'endDay', child: Text('End Day')),
              PopupMenuItem(value: 'save', child: Text('Save & Quit')),
            ],
          ),
        ],
      ),
    );
  }

  String _getInitials(GameState gs) {
    final f = gs.character?.firstName;
    final l = gs.character?.lastName;
    if (f == null && l == null) return '?';
    return '${f != null && f.isNotEmpty ? f[0] : ''}${l != null && l.isNotEmpty ? l[0] : ''}'.toUpperCase();
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'settings':
        context.push('/settings');
      case 'achievements':
        context.push('/achievements');
      case 'endDay':
        showDialog(context: context, builder: (_) => const ConfirmEndDay());
      case 'save':
        context.go('/save-selection');
    }
  }

  Widget _marketPage(GameState gs) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Area selector
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: AREAS.map((area) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(area),
                  selected: gs.area == area,
                  onSelected: (_) {
                    if (area != gs.area) {
                      ref.read(gameControllerProvider.notifier).travel(area);
                    }
                  },
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 12),
          const MarketTable(),
          const SizedBox(height: 16),
          // Quick actions
          Row(
            children: [
              Expanded(child: _actionChip(Icons.backpack, 'Stash', () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => DraggableScrollableSheet(
                    initialChildSize: 0.6,
                    minChildSize: 0.3,
                    maxChildSize: 0.9,
                    builder: (_, sc) => InventoryDrawer(scrollController: sc),
                  ),
                );
              })),
              const SizedBox(width: 8),
              Expanded(child: _actionChip(Icons.shield, 'Weapons', () {
                showModalBottomSheet(context: context, builder: (_) => const WeaponsShop());
              })),
              const SizedBox(width: 8),
              Expanded(child: _actionChip(Icons.assignment, 'Contracts', () {
                showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => const ContractsBoard());
              })),
            ],
          ),
          const SizedBox(height: 16),
          const EventFeed(),
        ],
      ),
    );
  }

  Widget _actionChip(IconData icon, String label, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: onTap,
    );
  }

  Widget _opsPage() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(tabs: [
            Tab(text: 'Combat'),
            Tab(text: 'Prison'),
            Tab(text: 'Bribery'),
          ]),
          Expanded(
            child: TabBarView(children: [
              const CombatHeistWidget(),
              const PrisonOperationsWidget(),
              const BriberyCorruptionWidget(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _empirePage() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(tabs: [
            Tab(text: 'Territory'),
            Tab(text: 'Interstate'),
            Tab(text: 'Prestige'),
            Tab(text: 'Federal'),
          ]),
          Expanded(
            child: TabBarView(children: [
              const TerritoryControlWidget(),
              const InterstateOperationsWidget(),
              const PrestigeSystemWidget(),
              const FederalInvestigationsWidget(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _crewPage() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(tabs: [
            Tab(text: 'Gang Wars'),
            Tab(text: 'Loyalty'),
            Tab(text: 'Legal'),
          ]),
          Expanded(
            child: TabBarView(children: [
              GangWarfareWidget(),
              const CrewLoyaltyWidget(),
              const LawyerSystemWidget(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _youPage(GameState gs) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Character card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: const Color(0xFFFFD700),
                    child: Text(
                      _getInitials(gs),
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${gs.character?.firstName ?? "Unknown"} ${gs.character?.lastName ?? ""}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text('Age: ${gs.character?.age ?? "?"}  \u2022  ${gs.area}',
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Stat badges row
          Row(
            children: [
              _statBadge('Cash', Formatters.moneyShort(gs.cash), Colors.green),
              const SizedBox(width: 8),
              _statBadge('Bank', Formatters.moneyShort(gs.bank), Colors.blue),
              const SizedBox(width: 8),
              _statBadge('Energy', '${gs.energy}/${100}', Colors.amber),
            ],
          ),
          const SizedBox(height: 12),
          GoalProgressPill(gameState: gs),
          const SizedBox(height: 16),
          // Nav grid
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              _navTile(Icons.bar_chart, 'Stats', () {
                showModalBottomSheet(context: context, isScrollControlled: true,
                    builder: (_) => const StatisticsDashboard());
              }),
              _navTile(Icons.receipt_long, 'History', () {
                showModalBottomSheet(context: context, isScrollControlled: true,
                    builder: (_) => const TransactionHistoryWidget());
              }),
              _navTile(Icons.backpack, 'Inventory', () {
                showModalBottomSheet(context: context, isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => DraggableScrollableSheet(
                      initialChildSize: 0.6, minChildSize: 0.3, maxChildSize: 0.9,
                      builder: (_, sc) => InventoryDrawer(scrollController: sc),
                    ));
              }),
              _navTile(Icons.emoji_events, 'Achievements', () => context.push('/achievements')),
              _navTile(Icons.settings, 'Settings', () => context.push('/settings')),
              _navTile(Icons.nights_stay, 'End Day', () {
                showDialog(context: context, builder: (_) => const ConfirmEndDay());
              }),
            ],
          ),
          const SizedBox(height: 16),
          const ActivityLogSheet(),
        ],
      ),
    );
  }

  Widget _statBadge(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _navTile(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFFFD700), size: 28),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
