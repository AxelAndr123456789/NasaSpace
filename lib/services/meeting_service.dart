import 'package:share_plus/share_plus.dart';

/// Datos de la sala de videoconsulta AURA+.
///
/// Se usa tanto en web (iframe de Jitsi) como en móvil/escritorio
/// (SDK nativo o apertura en el navegador).
class MeetingService {
  MeetingService._();

  /// Servidor de Jitsi utilizado por la app.
  ///
  /// Se usa `meet.hostpoint.ch` (instancia pública de Hostpoint, Suiza)
  /// porque cumple las tres condiciones necesarias:
  ///  * permite entrar a una sala nueva **sin iniciar sesión**,
  ///  * **permite embeber** la sala en un iframe (sin `X-Frame-Options`),
  ///  * no limita la duración ni el número de participantes.
  ///
  /// El servidor oficial `meet.jit.si` exige que el primer participante se
  /// autentique con Google / Facebook / GitHub, lo que rompería la
  /// videollamada; `meet.ffmuc.net` no permite embeberlo en un iframe.
  static const String servidor = 'https://meet.hostpoint.ch';

  /// Identificador de la sala (mismo para las dos personas).
  static const String sala = 'aura-consulta-er001';

  /// Enlace completo de la reunión.
  static const String enlace = '$servidor/$sala';

  /// Comparte el enlace de la sala con la otra persona.
  static Future<void> compartirEnlace() async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: 'Te invito a la consulta AURA+: $enlace',
          title: 'Reunión AURA+',
        ),
      );
    } catch (_) {
      // El navegador puede bloquear el menú de compartir: no es crítico.
    }
  }
}
