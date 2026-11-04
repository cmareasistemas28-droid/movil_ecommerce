import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.destination});

  static const logoAsset = 'assets/images/branding/ciber_max_logo.jpg';
  // Average perimeter color of the supplied image, shared with native launch.
  static const backgroundColor = Color(0xFFF6F9FA);
  static const animationDuration = Duration(milliseconds: 400);
  static const transitionDuration = Duration(milliseconds: 100);
  final String destination;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;
  late final Animation<Offset> _movement;
  bool _started = false;
  bool _leaving = false;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: SplashPage.animationDuration,
      animationBehavior: AnimationBehavior.preserve,
    )..addStatusListener(_onStatus);
    _opacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 24,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 56),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
    ]).animate(_controller);
    _scale = Tween(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.72, curve: Curves.easeOutCubic),
      ),
    );
    _movement = Tween(begin: const Offset(0, 0.025), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.75, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (!_started) {
      _started = true;
      // The native screen stays up until Flutter's first frame. No network or
      // artificial initialization work is added to startup.
      _controller.duration = SplashPage.animationDuration;
      _controller.forward();
    }
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted || _leaving) return;
    _leaving = true;
    Navigator.of(context).pushReplacementNamed(widget.destination);
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onStatus);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: SplashPage.backgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    child: Scaffold(
      backgroundColor: SplashPage.backgroundColor,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.white, SplashPage.backgroundColor],
            stops: [0.25, 1],
            radius: 1,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = (constraints.maxWidth * 0.86).clamp(0.0, 288.0);
                final image = Image.asset(
                  SplashPage.logoAsset,
                  width: width,
                  height: (width * 1536 / 2816).clamp(
                    0.0,
                    constraints.maxHeight * 0.8,
                  ),
                  fit: BoxFit.contain,
                  semanticLabel: 'CIBER-MAX',
                  errorBuilder: (_, _, _) => const Text(
                    'CIBER-MAX',
                    style: TextStyle(
                      color: Color(0xFF252A30),
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                );
                // The JPEG has a subtle gradient. Feather only its outer blank
                // margins so it blends into the canvas without altering the logo.
                final logo = ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white,
                      Colors.white,
                      Colors.transparent,
                    ],
                    stops: [0, 0.1, 0.9, 1],
                  ).createShader(bounds),
                  child: ShaderMask(
                    blendMode: BlendMode.dstIn,
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white,
                        Colors.white,
                        Colors.transparent,
                      ],
                      stops: [0, 0.1, 0.9, 1],
                    ).createShader(bounds),
                    child: image,
                  ),
                );
                return Semantics(
                  label: 'Iniciando CIBER-MAX',
                  child: _reduceMotion
                      ? logo
                      : FadeTransition(
                          key: const Key('splash-fade'),
                          opacity: _opacity,
                          child: ScaleTransition(
                            scale: _scale,
                            child: SlideTransition(
                              position: _movement,
                              child: logo,
                            ),
                          ),
                        ),
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}
