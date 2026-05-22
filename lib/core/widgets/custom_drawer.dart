import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttershop/constants/images_constans.dart';
import 'package:fluttershop/features/auth/presentation/cubit/authbloc.dart';
import 'package:fluttershop/features/auth/presentation/cubit/authevent.dart';
import 'package:fluttershop/core/cubit/theme_cubit.dart';
import 'package:fluttershop/features/product/presentation/pages/fav.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttershop/features/auth/presentation/cubit/authstate.dart';
import 'package:fluttershop/helper/name_generator.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            accountName: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                String displayName = "Guest";
                if (authState is AuthAuthenticated) {
                  displayName = NameGenerator.getDisplayName(authState.user);
                } else {
                  displayName = NameGenerator.getDisplayName(null);
                }
                return Text(
                  "Hi, $displayName",
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                );
              },
            ),
            accountEmail: null,
            currentAccountPicture: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage(ImagesConstans.Draweruser),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: Text("Favorites", style: GoogleFonts.lato(fontSize: 18)),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Favorit()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text("Logout", style: GoogleFonts.lato(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(SignOutRequested());
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Dark Mode", style: GoogleFonts.lato(fontSize: 18)),
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, state) {
                    return Switch(
                      value: state == ThemeMode.dark,
                      onChanged: (value) {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                      activeColor: Colors.deepPurple,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
