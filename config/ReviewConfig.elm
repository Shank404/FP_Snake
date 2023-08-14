module ReviewConfig exposing (config)

{-| This file configures elm-review

Please do not change anything here

-}


import CognitiveComplexity
import Import.NoCoreModule
import Import.QualifiedDefault
import NoDebug.Log
import NoDebug.TodoOrToString
import NoExposingEverything
import NoForbiddenFeature
import NoImportingEverything
import NoLetSequence
-- import NoMinimalRecordAccess
import NoMinimalUnderscorePattern
import NoMissingTypeAnnotation
import NoNegatedIfCondition
import NoNegationOfBooleanOperator
import NoPrimitiveTypeAlias
import NoRecursiveUpdate
import NoSimpleLetBody
import NoSinglePatternCase
import NoStringBasedProgramming
import NoUnnecessaryLambdaExpression
import NoUnnecessaryReconstruction
import NoUnused.CustomTypeConstructors
import NoUnused.Dependencies
import NoUnused.Exports
import NoUnused.Modules
import NoUnused.Parameters
import NoUnused.Patterns
import NoUnused.Variables
import NoUselessSubscriptions
import RemoveCodeDuplication
import Review.Rule exposing (Rule)
import Simplify
import SimplifyCase
import UseCamelCase
import UseConditionalForIntegers
import UseConstantForStyle
import UseEtaReduction
import UseFunctionComposition
import UseInvertedOperator
import UseLogicalOperator
import UseNamingConvention
import UsePatternMatching
import UsePredefinedFunction
import UseProperHTML
import UseRecordUpdate
import UseStructuredDataTypes


config : List Rule
config =
    [ Import.NoCoreModule.rule
    , Import.QualifiedDefault.ruleWithExceptions
        { unqualified =
            [ { moduleName = "Html", exceptions = [ "map" ] }
            , { moduleName = "Html.Attributes", exceptions = [] }
            , { moduleName = "Html.Events", exceptions = [] }
            , { moduleName = "Svg", exceptions = [] }
            , { moduleName = "Svg.Attributes", exceptions = [] }
            ]
        , ignored =
            [ "Browser.Events"
            , "Element"
            , "Css"
            , "Css.Animations"
            , "Css.Transitions"
            , "Html.Styled"
            , "Html.Styled.Attributes"
            , "Html.Styled.Events"
            , "Svg.Styled"
            , "Svg.Styled.Attributes"
            , "Canvas"
            , "Canvas.Settings"
            , "Canvas.Settings.Line"
            , "Canvas.Settings.Text"
            ]
        }
    , NoDebug.Log.rule
    , NoDebug.TodoOrToString.rule
    , NoExposingEverything.rule
    , NoForbiddenFeature.rule
        { features =
            { letIn = False
            , algebraicDataTypes = False
            , lambda = False
            }
        , globalDefinitions =
            { operators =
                []
            , functions =
                [ "List.append"
                , "Task.perform"
                , "Task.succeed"
                ]
            }
        , localDefinitions =
            [ ( "List.NonEmpty"
              , { operators = [ "++" ]
                , functions = []
                }
              )
            , ( "List.Extra"
              , { operators = [ "++", "::" ]
                , functions = []
                }
              )
            ]
        }
    , NoImportingEverything.rule []

    -- , NoMinimalRecordAccess.rule
    , NoMinimalUnderscorePattern.rule 3
    , NoMissingTypeAnnotation.rule
    , NoNegatedIfCondition.rule
    , NoNegationOfBooleanOperator.rule
    , NoPrimitiveTypeAlias.rule
    , NoRecursiveUpdate.rule
    , NoSimpleLetBody.rule
    , NoSinglePatternCase.rule NoSinglePatternCase.fixInArgument
    , NoStringBasedProgramming.rule
    , NoUnnecessaryLambdaExpression.rule
    , NoUnnecessaryReconstruction.rule
    , NoUnused.CustomTypeConstructors.rule []
    , NoUnused.Dependencies.rule
    , NoUnused.Exports.rule
    , NoUnused.Modules.rule
    , NoUnused.Parameters.rule
    , NoUnused.Patterns.rule
    , NoUnused.Variables.rule
    , NoUselessSubscriptions.rule
    , RemoveCodeDuplication.rule
    , Simplify.rule Simplify.defaults
    , SimplifyCase.rule
    , UseCamelCase.rule UseCamelCase.default
    , UseConditionalForIntegers.rule
    , UseConstantForStyle.rule
    , UseEtaReduction.rule UseEtaReduction.ModuleError
    , UseFunctionComposition.rule
    , UseInvertedOperator.rule
    , UseNamingConvention.rule
    , UseLogicalOperator.rule
    , UsePatternMatching.rule
    , UsePredefinedFunction.rule
    , UseProperHTML.rule
    , UseRecordUpdate.rule
    , UseStructuredDataTypes.rule
    ]
