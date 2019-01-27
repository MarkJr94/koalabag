import 'package:built_collection/built_collection.dart';

import 'package:koalabag/model/tag.dart';

class TagReq {}

class TagReqOk {}

class TagFail {
  final dynamic err;

  TagFail(this.err);
}

class LoadTags extends TagReq {}

class LoadTagsOk extends TagReqOk {
  BuiltList<Tag> tags;

  LoadTagsOk(this.tags);
}

class AddTag extends TagReq {
  final int entryId;
  final String tag;

  AddTag(this.entryId, this.tag);
}

class AddTagOk extends TagReqOk {
  final Tag tag;

  AddTagOk(this.tag);
}

class RemoveTag extends TagReq {
  final int entryId;
  final Tag tag;

  RemoveTag(this.entryId, this.tag);
}

class RemoveTagOk extends TagReqOk {
  final Tag tag;

  RemoveTagOk(this.tag);
}

class DeleteTag extends TagReq {
  final Tag tag;

  DeleteTag(this.tag);
}

class DeleteTagOk extends TagReqOk {
  final Tag tag;

  DeleteTagOk(this.tag);
}
