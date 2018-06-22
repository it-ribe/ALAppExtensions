﻿// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved. 
// Licensed under the MIT License. See License.txt in the project root for license information. 
// ------------------------------------------------------------------------------------------------

page 2029 "Image Analyzer Wizard"
{
    PageType = NavigatePage;
    Caption = 'Image Analyzer assisted setup guide';
    layout
    {
        area(content)
        {
            group(MediaStandard)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible;
                field("MediaResourcesStandard.""Media Reference"""; MediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }

            group(FirstPage)
            {

                Caption = '';
                Visible = FirstStepVisible;
                group("Welcome to the Wizard")
                {
                    Caption = 'Welcome';
                    Visible = FirstStepVisible;
                    group(TourGroup)
                    {
                        Caption = '';
                        InstructionalText = 'Image Analyzer uses the Computer Vision API from Microsoft Cognitive Services to detect attributes in the images you upload for items and contact persons, so it''s easy for you to assign them. For items, Image Analyzer finds attributes like type and color. For contact persons, it detects age and gender.';
                        Visible = FirstStepVisible;

                        group(LearnMoreLinkGroup)
                        {
                            Caption = '';

                            field(CanLearnMore; YouCanLearnMoreTxt)
                            {
                                ApplicationArea = Basic, Suite;
                                ShowCaption = false;
                                Editable = false;
                                MultiLine = true;
                            }

                            field(Link; LearnMoreStatementLinkTxt)
                            {
                                ApplicationArea = Basic, Suite;
                                ShowCaption = false;
                                Editable = false;

                                trigger OnDrillDown()
                                begin
                                    Hyperlink(LearnMoreLink);
                                end;
                            }

                            field(CognitiveServicesLink; CognitiveServicesLinkTxt)
                            {
                                ApplicationArea = Basic, Suite;
                                ShowCaption = false;
                                Editable = false;

                                trigger OnDrillDown()
                                begin
                                    Hyperlink(CognitiveServicesLink);
                                end;
                            }

                        }
                    }
                }
            }

            group(SecondPage)
            {

                Caption = '';
                Visible = SecondStepVisible;
                group("Terms of use")
                {
                    Caption = 'Terms of Use';
                    Visible = SecondStepVisible;
                    field(ConsentPart; ConsentTxt)
                    {
                        ApplicationArea = Basic, Suite;
                        ShowCaption = false;
                        Editable = false;
                        MultiLine = true;
                    }

                    field(ImageAnalyzerDocumentation; ImageAnalyzerDocumentationTxt)
                    {
                        ApplicationArea = Basic, Suite;
                        ShowCaption = false;
                        Editable = false;

                        trigger OnDrillDown()
                        begin
                            Hyperlink(ImageAnalyzerDocumentationLink);
                        end;
                    }

                    field(TermsPart; TermsPart)
                    {
                        ApplicationArea = Basic, Suite;
                        ShowCaption = false;
                        Editable = false;
                        MultiLine = true;
                    }

                    field(TermsPartLink; OnlineServicesTermLinkTxt)
                    {
                        ApplicationArea = Basic, Suite;
                        ShowCaption = false;
                        Editable = false;

                        trigger OnDrillDown()
                        begin
                            Hyperlink(OnlineServicesTermLink);
                        end;
                    }

                    field(Space; ' ')
                    {
                        ApplicationArea = Basic, Suite;
                        ShowCaption = false;
                        Editable = false;
                        MultiLine = true;
                    }

                    field(EnableFeature; EnableFeature)
                    {
                        ApplicationArea = Basic, Suite;
                        MultiLine = true;
                        Editable = true;
                        Caption = 'I understand and accept these terms';
                        trigger OnValidate()
                        begin
                            ShowSecondStep();
                        end;
                    }
                }
            }

            group(FinalPage)
            {
                Caption = '';
                Visible = FinalStepVisible;

                group("That's it!")
                {
                    Caption = 'That''s it!';

                    group(ChooseFinishGroup)
                    {
                        Caption = '';
                        Visible = true;
                        field(ChooseFinish; ChooseFinishTxt)
                        {
                            ApplicationArea = Basic, Suite;
                            ShowCaption = false;
                            Editable = false;
                            MultiLine = true;
                        }
                    }

                    group(HowToGroup)
                    {
                        Caption = '';
                        Visible = true;

                        field(HowToPart1; HowToPart1)
                        {
                            ApplicationArea = Basic, Suite;
                            ShowCaption = false;
                            Editable = false;
                            MultiLine = true;
                        }

                        field(HowToPart2; HowToPart2)
                        {
                            ApplicationArea = Basic, Suite;
                            ShowCaption = false;
                            Editable = false;
                            MultiLine = true;
                        }
                    }

                    group(AnalyzePicture)
                    {
                        Caption = '';
                        Visible = HasPicture;

                        field(HowTo2; WantToAnalyzeTheCurrentPictureQst)
                        {
                            ApplicationArea = Basic, Suite;
                            ShowCaption = false;
                            Editable = false;
                            MultiLine = true;
                        }

                        field(AnalyzePictureOnFinish; AnalyzePictureOnFinish)
                        {
                            ApplicationArea = Basic, Suite;
                            ShowCaption = true;
                            Editable = true;
                            Caption = 'Analyze current picture';
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ActionBack)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Back';
                Enabled = BackActionEnabled;
                Visible = BackActionEnabled;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Next';
                Enabled = NextActionEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(false);
                end;
            }

            action(ActionFinishAndEnable)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Finish';
                Enabled = FinalStepVisible;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                begin
                    FinishAndEnableAction();
                end;
            }
        }
    }

    trigger OnInit()
    begin
        LoadTopBanners();
    end;

    trigger OnOpenPage()
    begin
        Step := Step::Start;
        EnableControls();

        if IsSetItemToFill then
            HasPicture := ItemToFill.Picture.Count() = 1;

        if IsSetContactToFill then
            HasPicture := (ContactToFill.Type = ContactToFill.Type::Person) and (ContactToFill.Image.HasValue());
    end;

    var
        MediaRepositoryStandard: Record "Media Repository";
        MediaResourcesStandard: Record "Media Resources";
        ItemToFill: Record Item;
        ContactToFill: Record Contact;
        Step: Option Start,Second,Finish;
        [InDataSet]
        TopBannerVisible: Boolean;
        [InDataSet]
        FirstStepVisible: Boolean;
        [InDataSet]
        SecondStepVisible: Boolean;
        [InDataSet]
        FinalStepVisible: Boolean;
        [InDataSet]
        FinishActionEnabled: Boolean;
        [InDataSet]
        BackActionEnabled: Boolean;
        [InDataSet]
        NextActionEnabled: Boolean;
        LearnMoreStatementLinkTxt: Label 'Computer Vision API documentation';
        LearnMoreLink: Label 'https://go.microsoft.com/fwlink/?linkid=848400';
        YouCanLearnMoreTxt: Label 'To learn more about Cognitive Services and the Computer Vision API, see the documentation.';
        ConsentTxt: Label 'By enabling the Image Analyzer extension you consent to sharing your data with an external system. For more information, see the documentation.';
        ImageAnalyzerDocumentationTxt: Label 'Image Analyzer technical documentation';
        ImageAnalyzerDocumentationLink: Label 'https://docs.microsoft.com/en-us/dynamics365/business-central/ui-extensions-image-analyzer';
        ChooseFinishTxt: Label 'Choose ''Finish'' to enable Image Analyzer.';
        HowToPart1: Label 'Image Analyzer automatically detects attributes when you add an image to an item or contact person.';
        HowToPart2: Label 'To analyze images you''ve already uploaded, go to the item or contact person card, and choose the ''Analyze Picture'' action.';
        TermsPart: Label 'Your use of the Image Analyzer may be subject to the additional licensing terms in the Microsoft Cognitive Services section of the Online Services Terms.';
        OnlineServicesTermLink: Label 'https://www.microsoft.com/en-us/licensing/product-licensing/products.aspx', Locked = true;
        OnlineServicesTermLinkTxt: Label 'Online Services Terms (OST)';
        CognitiveServicesLink: Label 'http://go.microsoft.com/fwlink/?LinkID=829046', Locked = true;
        CognitiveServicesLinkTxt: Label 'Microsoft Cognitive Services';
        WantToAnalyzeTheCurrentPictureQst: Label 'An image has been added to the chosen item or contact. Want to analyze the image, right after you enable Image Analyzer?';
        IsSetContactToFill: Boolean;
        IsSetItemToFill: Boolean;
        AnalyzePictureOnFinish: Boolean;
        HasPicture: Boolean;
        EnableFeature: Boolean;

    local procedure EnableControls()
    begin
        ResetControls();

        case Step of
            Step::Start:
                ShowStartStep();

            Step::Second:
                ShowSecondStep();

            Step::Finish:
                ShowFinalStep();
        END;
    end;

    local procedure NextStep(Backwards: Boolean)
    begin

        if Backwards then
            Step := Step - 1
        ELSE
            Step := Step + 1;

        EnableControls();
    end;

    local procedure FinishAndEnableAction()
    var
        ItemAttrPopulate: Codeunit "Item Attr Populate";
        ContactPictureAnalyze: Codeunit "Contact Picture Analyze";
        ItemAttrPopManagement: Codeunit "Image Analyzer Ext. Mgt.";
    begin
        ItemAttrPopManagement.HandleSetupAndEnable();
        CurrPage.Close();

        if not AnalyzePictureOnFinish then
            exit;

        if IsSetItemToFill then
            ItemAttrPopulate.OnAfterImportPictureAnalyzePicture(ItemToFill);

        if IsSetContactToFill then
            ContactPictureAnalyze.OnAfterImportPictureAnalyzePicture(ContactToFill);
    end;

    local procedure ShowStartStep()
    begin
        FirstStepVisible := true;
        SecondStepVisible := false;
        FinishActionEnabled := false;
        BackActionEnabled := false;
    end;

    local procedure ShowSecondStep()
    begin
        FirstStepVisible := false;
        SecondStepVisible := true;
        FinishActionEnabled := false;
        BackActionEnabled := true;
        NextActionEnabled := EnableFeature;
    end;

    local procedure ShowFinalStep()
    begin
        FinalStepVisible := true;
        BackActionEnabled := true;
        NextActionEnabled := false;
    end;

    local procedure ResetControls()
    begin
        FinishActionEnabled := true;
        BackActionEnabled := true;
        NextActionEnabled := true;

        FirstStepVisible := false;
        SecondStepVisible := false;
        FinalStepVisible := false;
    end;

    local procedure LoadTopBanners()
    begin
        if MediaRepositoryStandard.Get('ImageAnalysis-Setup-NoText.png', Format(CurrentClientType())) then
            if MediaResourcesStandard.Get(MediaRepositoryStandard."Media Resources Ref") then
                TopBannerVisible := MediaResourcesStandard."Media Reference".HasValue();
    end;

    procedure SetItem(Item: Record Item)
    begin
        ItemToFill := Item;
        IsSetItemToFill := true;
    end;

    procedure SetContact(Contact: Record Contact)
    begin
        ContactToFill := Contact;
        IsSetContactToFill := true;
    end;
}
