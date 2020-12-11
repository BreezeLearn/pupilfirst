open CurriculumEditor__Types

type props = {
  course: Course.t,
  evaluationCriteria: list<EvaluationCriteria.t>,
  levels: array<Level.t>,
  targetGroups: list<TargetGroup.t>,
  targets: list<Target.t>,
  hasVimeoAccessToken: bool,
  vimeoAccountPlan: string,
}

let decodeProps = json => {
  open Json.Decode
  {
    course: json |> field("course", Course.decode),
    evaluationCriteria: json |> field("evaluationCriteria", list(EvaluationCriteria.decode)),
    levels: json |> field("levels", array(Level.decode)),
    targetGroups: json |> field("targetGroups", list(TargetGroup.decode)),
    targets: json |> field("targets", list(Target.decode)),
    hasVimeoAccessToken: json |> field("hasVimeoAccessToken", bool),
    vimeoAccountPlan: json |> field("vimeoAccountPlan", string),
  }
}

let props =
  DomUtils.parseJSONAttribute(~id="curriculum-editor", ~attribute="data-props", ()) |> decodeProps

ReactDOMRe.renderToElementWithId(
  <CurriculumEditor
    course=props.course
    evaluationCriteria=props.evaluationCriteria
    levels=props.levels
    targetGroups=props.targetGroups
    targets=props.targets
    hasVimeoAccessToken=props.hasVimeoAccessToken
    vimeoAccountPlan=props.vimeoAccountPlan
  />,
  "curriculum-editor",
)
