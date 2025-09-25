import 'package:dental/common_color.dart';
import 'package:dental/text_styles.dart';
import 'package:flutter/material.dart';

class DoctorProfilePage extends StatelessWidget {
  const DoctorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5A46F3), AppColors.peacockBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 8,
                    top: 8,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white70),
                      onPressed: () {},
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                const Text(
                                  "Dr. Ani Sharma",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  "Orthodontist",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 14),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: const [
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 18),
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 18),
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 18),
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 18),
                                    Icon(Icons.star_half,
                                        color: Colors.amber, size: 18),
                                    SizedBox(width: 8),
                                    Text("4.8",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            child: ClipOval(
                              child: Image.network(
                                "https://images.unsplash.com/photo-1537368910025-700350fe46c7?q=80&w=1200&auto=format&fit=crop&ixlib=rb-4.0.3&s=0b6d4a1f2f6e3aa7f9c0b4f5f7b9c8d7",
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(
                                  color: Colors.white,
                                  child: Icon(Icons.person,
                                      size: 56, color: Colors.grey.shade400),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // About
                    _infoCard(
                      title: "About",
                      child: const Text(
                        "Dr. Ani Sharma has over a decade of experience in corrective dentistry and orthodontics. "
                            "She focuses on patient-centred care and uses the latest minimally invasive techniques.",
                        style: TextStyle(height: 1.4),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Experience & Clinic
                    Row(
                      children: [
                        Expanded(
                          child: _infoCard(
                              title: "Experience",
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("12 years",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 6),
                                  Text("of practice",
                                      style:
                                      TextStyle(color: Colors.grey)),
                                ],
                              )),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _infoCard(
                              title: "Clinic",
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("BrightSmile Dental Clinic",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(height: 6),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.location_on,
                                          size: 16, color: Colors.grey),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                            "221B Baker Street, Springfield",
                                            style: TextStyle(
                                                color: Colors.grey)),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Actions
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: _actionButton(
                                  icon: Icons.call,
                                  label: "Call",
                                  color: Colors.green),
                            ),
                            VerticalDivider(),
                            Expanded(
                              child: _actionButton(
                                  icon: Icons.message,
                                  label: "Message",
                                  color: Colors.blue),
                            ),
                            VerticalDivider(),
                            Expanded(
                              child: _actionButton(
                                  icon: Icons.calendar_today,
                                  label: "Book",
                                  color: const Color(0xFF5A46F3)),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Reviews
                    _infoCard(
                      title: "Patient Reviews",
                      child: Column(
                        children: [
                          _reviewTile(
                              "Sahana", 5, "Very professional and caring."),
                          const Divider(),
                          _reviewTile("Raj", 4, "Good experience, painless treatment."),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text("See all reviews"),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label:  Text("Book Appointment",style: AppTextStyles.labelText(context,color: AppColors.white),),
        icon: const Icon(Icons.calendar_today,color: AppColors.white,),
        backgroundColor: AppColors.peacockBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _infoCard({required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
      {required IconData icon, required String label, required Color color}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: Colors.grey.shade800)),
        ],
      ),
    );
  }

  Widget _reviewTile(String name, int rating, String comment) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(child: Text(name[0])),
      title: Row(
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Row(
            children: List.generate(rating, (i) {
              return const Icon(Icons.star, color: Colors.amber, size: 14);
            }),
          ),
        ],
      ),
      subtitle: Text(comment),
    );
  }
}
