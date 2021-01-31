/// Define how you want the navgiation to react.
abstract class QNavigationMode {}

/// [Push] place the new page on the top of the stack.
/// and don't remove the last one.
class Push extends QNavigationMode {}

/// [ReplaceAll] remove all page from the stack and place this on on the top.
class ReplaceAll extends QNavigationMode {}

/// [ReplaceLast] replace the last page with this page.
class ReplaceLast extends QNavigationMode {}

/// [PopUntilOrPush] Pop all page unit you get this page in the stack
/// if the page doesn't exist in the stack push in on the top.
class PopUntilOrPush extends QNavigationMode {
  final String name;
  PopUntilOrPush(this.name);
}

class Pop extends QNavigationMode {}

enum NavigationType {
  Push,
  Pop,
  ReplaceAll,
  ReplaceLast,
  PopUntilOrPush,
}
