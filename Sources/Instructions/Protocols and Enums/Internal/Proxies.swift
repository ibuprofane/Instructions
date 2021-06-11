// Copyright (c) 2021-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import Foundation

internal protocol TutorialControllerDataSourceProxy: AnyObject {
    func numberOfCoachMarks() -> Int
    func configurationForCoachMark(at index: Int) -> CoachMarkConfiguration
    func compoundViewFor(coachMark: CoachMarkConfiguration, at index: Int) -> CoachMarkViewComponents
}

protocol TutorialControllerDelegateProxy: AnyObject {
    func shouldLoadConfigurationForCoachMark(at index: Int) -> Bool

    func willShowCoachMark(
        with configuration: CoachMarkConfiguration,
        after configurationChange: ConfigurationChange?,
        at index: Int
    )

    func didShowCoachMark(
        with configuration: CoachMarkConfiguration,
        after configurationChange: ConfigurationChange?,
        at index: Int
    )

    func willHideCoachMark(with configuration: CoachMarkConfiguration, at index: Int)
    func didHideCoachMark(with configuration: CoachMarkConfiguration, at index: Int)
    func didEndTutorial(bySkipping skipped: Bool)
    func shouldHandleOverlayTap(at index: Int) -> Bool
}

protocol TutorialControllerDelegateAnimationProxy: TutorialControllerDelegateProxy {
    func willDisplay(
        coachMark: UIView,
        at index: Int,
        transitioner: CoachMarkTransitionManager
    )

    func willEndDisplaying(
        coachMark: UIView,
        at index: Int,
        transitioner: CoachMarkTransitionManager
    )

    func animate(
        coachMark: UIView,
        at index: Int,
        animator: CoachMarkAnimationManager
    )
}
