{$I Wasplib/osrs.simba}
{$I TRSHerblore.simba}
type
 THerb = record
    Actions, MaxTime, MaxActions, MaxLevel: UInt64;
    FormSetting: Boolean;
    Herb:TRSItem;
  end;

procedure THerb.Init;

begin

end;

function THerb.AssignStates:EHerbActions;
begin
 If ACTIONS[0]<>'' then
  begin
    If AVAILABLE_HERBS[0].Grimy<>'' then
    exit (EHerbActions.CLEAN);
  end;
end;

procedure THerb.MainRun; //Uses previous function to link states to 1 to 1 actions.
  var
  action: EHerbActions;

begin
 while GetTimeRunning < (MAX_RUNTIME_MINUTES * ONE_MINUTE) do

  begin
    action := Self.AssignStates;
    WriteLn(action);
    case action of
      EHerbActions.CLEAN:herb.cleanherbs([(AVAILABLE_HERBS[0].Grimy)]);
    end;
  end;
end;

///////////////////////////////////FORM STUFF\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
var
  Template: THerb;
  TemplateForm: TScriptForm;
  TemplateConfig: TConfigJSON;
  FormCheckbox: TLazCheckBox;
  HerbCombobox, ActionCombobox: TLazComboBox;

procedure TScriptForm.OnStart(sender: TLazObject); override;
begin
  inherited;

  if TemplateConfig.Data.Has('form_setting') then
    TemplateConfig.Data.Item['form_setting'].AsBool := Template.FormSetting
  else
    TemplateConfig.Data.AddBool('form_setting', Template.FormSetting);

  Template.MaxActions := Self.Goals.Actions.Value;
  Template.MaxTime    := Self.Goals.Time.Value * ONE_MINUTE;
  Template.MaxLevel   := Self.Goals.Level.Value;

  TemplateConfig.Save();
end;

procedure TScriptForm.Init();
var
  tab: TLazTabSheet;
  panel: TLazPanel;
  act: EHerbActions;
  herb:THerbType;
begin
  TemplateConfig.Setup('scripts' + PATH_SEP + 'my-script-name');

  Self.Setup('My Script Name', TemplateConfig.Data);

  tab := Self.CreateTab('My Script Name');
  panel := Self.CreateGoals(tab, True, True, True, EOrientation.HORIZONTAL);
  panel.Align := ELazAlign.Bottom;

  HerbComboBox:= TLazComboBox.CreateEx(tab, 'Herb Type:', 'Choose Herb', 20, 100, 200);
  for herb in AVAILABLE_HERBS do
    HerbComboBox.Items.Add(herb.Grimy);
  HerbComboBox.ItemIndex := 0;

  ActionComboBox:= TLazComboBox.CreateEx(tab, 'Action:', 'Make Unfinished or Clean', 20, 160, 200);
    ActionComboBox.Items.add(ACTIONS[0]);
    ActionComboBox.Items.add(ACTIONS[1]);
    ActionComboBox.ItemIndex:=0;

  Self.CreateAntibanTab();
  Self.Run();
end;

 var
 run:THerb;
begin

  TemplateForm.Init();

  //run.init;
  //herb.MakeUnfinished(AVAILABLE_HERBS[0].Clean);
  run.MainRun;

end. 
