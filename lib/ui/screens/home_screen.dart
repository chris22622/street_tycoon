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
import '../widgets/territory_control.dart';
import '../widgets/prestige_system.dart';
import '../widgets/federal_investigation.dart';
import '../widgets/activity_log_sheet.dart';
import '../widgets/crime_sheet.dart';
import '../widgets/face_sprite_widget.dart';
import '../widgets/transaction_history_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameState = ref.read(gameControllerProvider);
      if (gameState.day == 1) {
        _showDisclaimerDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, gameState),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  _marketPage(context, gameState),
                  _opsPage(context, gameState),
                  _empirePage(context, gameState),
                  _crewPage(context, gameState),
                  _youPage(context, gameState),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.storefront), label: 'Market'),
          NavigationDestination(icon: Icon(Icons.flash_on), label: 'Ops'),
          NavigationDestination(icon: Icon(Icons.domain), label: 'Empire'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Crew'),
          NavigationDestination(icon: Icon(Icons.person), label: 'You'),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, dynamic gs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.push('/character-development'),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade800,
              child: gs.characterData != null
                  ? ClipOval(child: FaceSpriteWidget(characterData: gs.characterData!, size: 36))
                  : const Icon(Icons.person, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('\$${Formatters.money(gs.cash)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                Text('Day ${gs.day}/${gs.daysLimit} • ${gs.area}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.local_fire_department, size: 14, color: Colors.orange),
              const SizedBox(width: 3),
              Text('${gs.heat.toInt()}%', style: const TextStyle(fontSize: 11, color: Colors.orange)),
            ]),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, size: 22),
            onSelected: _handleMenuAction,
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'inventory', child: Text('Inventory')),
              const PopupMenuItem(value: 'stats', child: Text('Statistics')),
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
              const PopupMenuItem(value: 'achievements', child: Text('Achievements')),
            ],
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'inventory': _showInventoryDrawer(); break;
      case 'stats': _showStatisticsDashboard(); break;
      case 'settings': context.push('/settings'); break;
      case 'achievements': context.push('/achievements'); break;
    }
  }

  Widget _marketPage(BuildContext context, dynamic gs) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: GameConstants.areas.map((area) {
                final isSelected = gs.area == area;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(area, style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(gameControllerProvider.notifier).changeArea(area);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          const MarketTableUltraClean(),
          const SizedBox(height: 12),
          Row(
            children: [
              _actionChip(Icons.inventory_2, 'Pack', () => _showInventoryDrawer()),
              const SizedBox(width: 8),
              _actionChip(Icons.account_balance, 'Bank', () => _showBanking()),
              const SizedBox(width: 8),
              _actionChip(Icons.upgrade, 'Upgrades', () => _showUpgradesModal()),
              const SizedBox(width: 8),
              _actionChip(Icons.nights_stay, 'End Day', () => _showEndDayConfirmation()),
            ],
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 200, child: EventFeed()),
        ],
      ),
    );
  }

  Widget _actionChip(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 20),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10)),
          ]),
        ),
      ),
    );
  }

  Widget _opsPage(BuildContext context, dynamic gs) {
    return DefaultTabController(
      length: 4,
      child: Column(children: [
        const TabBar(isScrollable: true, tabs: [
          Tab(text: 'Contracts'),
          Tab(text: 'Arsenal'),
          Tab(text: 'Combat'),
          Tab(text: 'Prison'),
        ]),
        Expanded(child: TabBarView(children: [
          const CrimeSheet(),
          const WeaponsShop(),
          const CombatHeistNew(),
          const PrisonOperations(),
        ])),
      ]),
    );
  }

  Widget _empirePage(BuildContext context, dynamic gs) {
    return DefaultTabController(
      length: 5,
      child: Column(children: [
        const TabBar(isScrollable: true, tabs: [
          Tab(text: 'Assets'),
          Tab(text: 'Territory'),
          Tab(text: 'Interstate'),
          Tab(text: 'Prestige'),
          Tab(text: 'Federal'),
        ]),
        Expanded(child: TabBarView(children: [
          const AssetsManagementNew(),
          const TerritoryControl(),
          const InterstateOperations(),
          const PrestigeSystem(),
          const FederalInvestigation(),
        ])),
      ]),
    );
  }

  Widget _crewPage(BuildContext context, dynamic gs) {
    return DefaultTabController(
      length: 3,
      child: Column(children: [
        const TabBar(tabs: [
          Tab(text: 'Gang Wars'),
          Tab(text: 'Corruption'),
          Tab(text: 'Legal'),
        ]),
        Expanded(child: TabBarView(children: [
          const GangWarfare(),
          const BriberyCorruptionNew(),
          const CourtModals(),
        ])),
      ]),
    );
  }

  Widget _youPage(BuildContext context, dynamic gs) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.grey.shade800,
                child: gs.characterData != null
                    ? ClipOval(child: FaceSpriteWidget(characterData: gs.characterData!, size: 64))
                    : const Icon(Icons.person, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gs.characterData?.name ?? 'Unknown',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Reputation: ${gs.reputation}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
                ],
              )),
            ]),
          ),
        ),
        const SizedBox(height: 8),
        Row(children: [
          _statBadge('Cash', '\$${Formatters.money(gs.cash)}', Colors.green),
          const SizedBox(width: 8),
          _statBadge('Heat', '${gs.heat.toInt()}%', Colors.orange),
          const SizedBox(width: 8),
          _statBadge('Day', '${gs.day}/${gs.daysLimit}', Colors.blue),
        ]),
        const SizedBox(height: 8),
        const GoalProgressPill(),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.3,
          children: [
            _navTile(Icons.person_outline, 'Character', () => context.push('/character-development')),
            _navTile(Icons.business_center, 'Business', () => context.push('/business-management')),
            _navTile(Icons.emoji_events, 'Achieve', () => context.push('/achievements')),
            _navTile(Icons.map, 'World Map', () => context.push('/world-map')),
            _navTile(Icons.gavel, 'Legal', () => context.push('/legal-system')),
            _navTile(Icons.receipt_long, 'Activity', () => _showActivityLog()),
          ],
        ),
        const SizedBox(height: 12),
        const TransactionHistoryWidget(),
      ]),
    );
  }

  Widget _statBadge(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        ]),
      ),
    );
  }

  Widget _navTile(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ]),
      ),
    );
  }

  void _showDisclaimerDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text('Disclaimer'),
      content: const Text('This is a fictional simulation game. All activities depicted are entirely fictional and for entertainment purposes only.'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('I Understand'))],
    ));
  }

  void _showRandomEvent() {
    showDialog(context: context, builder: (context) => const RandomEventDialog());
  }

  void _showInventoryDrawer() {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => const InventoryDrawer());
  }

  void _showBanking() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AdvancedBankingScreen()));
  }

  void _showUpgradesModal() { showDialog(context: context, builder: (context) => const UpgradesModal()); }

  void _showCrimesSheet() {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => const CrimeSheet());
  }

  void _showActivityLog() {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => const ActivityLogSheet());
  }

  void _showEndDayConfirmation() { showDialog(context: context, builder: (context) => const ConfirmEndDay()); }

  void _showStatisticsDashboard() {
    showModalBottomSheet(context: context, isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(initialChildSize: 0.8, maxChildSize: 0.95, minChildSize: 0.5,
        builder: (context, sc) => Container(
          decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), color: Theme.of(context).scaffoldBackgroundColor),
          child: Column(children: [
            Container(margin: const EdgeInsets.only(top: 8), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(2))),
            Expanded(child: SingleChildScrollView(controller: sc, padding: const EdgeInsets.all(16), child: const StatisticsDashboard())),
          ]),
        )));
  }
}
