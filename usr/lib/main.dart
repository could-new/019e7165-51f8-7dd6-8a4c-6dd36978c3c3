import 'package:flutter/material.dart';

void main() {
  runApp(const CandidatePortalApp());
}

class CandidatePortalApp extends StatelessWidget {
  const CandidatePortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Candidate Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0052C2), // Corporate blue
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CandidatePortalHome(),
      },
    );
  }
}

class CandidatePortalHome extends StatefulWidget {
  const CandidatePortalHome({super.key});

  @override
  State<CandidatePortalHome> createState() => _CandidatePortalHomeState();
}

class _CandidatePortalHomeState extends State<CandidatePortalHome> {
  final List<DateTime> _selectedDates = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 14)),
      selectableDayPredicate: (DateTime val) =>
          val.weekday != DateTime.saturday && val.weekday != DateTime.sunday,
    );
    if (picked != null && !_selectedDates.contains(picked)) {
      setState(() {
        _selectedDates.add(picked);
      });
    }
  }

  void _removeDate(DateTime date) {
    setState(() {
      _selectedDates.remove(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidate Portal'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildMessageCard(context),
                const SizedBox(height: 24),
                _buildSchedulerCard(context),
                const SizedBox(height: 24),
                _buildResourcesCard(context),
                const SizedBox(height: 24),
                _buildAccommodationsCard(context),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, Kinjal!',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Data Center Operations Engineer 2026 (Contract)',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildMessageCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.mail_outline,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Interview Invitation',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const Divider(height: 32),
            const Text(
              'Great News! We would like to proceed with your application and schedule your next interview. '
              'For this next round we would like to invite you to speak with the team via video conference for approximately 60 minutes.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Best of luck,\nAbigail\nRecruiting Team',
              style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchedulerCard(BuildContext context) {
    final bool hasEnoughDates = _selectedDates.length >= 5;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_month,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Provide Availability',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const Divider(height: 32),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Please include at least 5 dates within the next two weeks. '
                      'The team typically interviews Monday - Friday between 9:00am - 4:00pm EST.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedDates.map((date) {
                return Chip(
                  label: Text('${date.month}/${date.day}/${date.year}'),
                  onDeleted: () => _removeDate(date),
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _selectDate(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Date'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: hasEnoughDates
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Availability submitted successfully!')),
                        );
                      }
                    : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  hasEnoughDates
                      ? 'Submit Availability'
                      : 'Select at least ${5 - _selectedDates.length} more date(s)',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourcesCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.library_books,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Preparation Resources',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const Divider(height: 32),
            const Text(
              'As part of your preparation, you may wish to review some of the following resources:',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            _buildResourceTile(
              context,
              icon: Icons.business,
              title: 'A Taste of Our Company',
              subtitle: 'Learn about our core business and values.',
            ),
            _buildResourceTile(
              context,
              icon: Icons.people_alt,
              title: 'Diversity & Inclusion',
              subtitle: 'Our mission to establish an inclusive work environment.',
            ),
            _buildResourceTile(
              context,
              icon: Icons.volunteer_activism,
              title: 'Bloomberg Philanthropies',
              subtitle: 'Giving back is essential to us here.',
            ),
            _buildResourceTile(
              context,
              icon: Icons.article,
              title: 'Company Blog',
              subtitle: 'Insights from our team and project updates.',
            ),
            _buildResourceTile(
              context,
              icon: Icons.gavel,
              title: 'How We Hire & Candidate Conduct',
              subtitle: 'Expectations on authentic self-representation.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceTile(BuildContext context,
      {required IconData icon, required String title, required String subtitle}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.open_in_new, size: 16),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening $title...')),
        );
      },
    );
  }

  Widget _buildAccommodationsCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.accessible_forward,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need Adjustments?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'It is important to us that you are able to perform to the best of your ability. '
                    'Please let us know should you require any adjustments, and we will make every effort to provide appropriate accommodations.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
