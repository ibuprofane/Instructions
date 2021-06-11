// Copyright (c) 2015-present Frédéric Maquin <fred@ephread.com> and contributors.
// Licensed under the terms of the MIT License.

import UIKit

/// This structure handle the parametrization of a given coach mark.
/// It doesn't provide any clue about the way it will look, however.
public struct CoachMarkConfiguration: Equatable {
    public var position: VerticalPosition = .automatic
    public var layout: CoachMarkLayoutConfiguration
    public var anchor: CoachMarkAnchorConfiguration
    public var interaction: CoachMarkInteractionConfiguration

    func computedConfiguration() -> ComputedCoachMarkConfiguration {
        ComputedCoachMarkConfiguration(
            position: <#T##ComputedVerticalPosition#>,
            layout: <#T##CoachMarkLayoutConfiguration#>,
            anchor: <#T##CoachMarkAnchorConfiguration#>,
            interaction: <#T##CoachMarkInteractionConfiguration#>
        )
    }
}

public struct ComputedCoachMarkConfiguration: Equatable {
    public let position: ComputedVerticalPosition
    public let layout: CoachMarkLayoutConfiguration
    public let anchor: CoachMarkAnchorConfiguration
    public let interaction: CoachMarkInteractionConfiguration
}

public struct CoachMarkLayoutConfiguration: Equatable {
    /// The vertical offset for the arrow (in rare cases, the arrow might need to overlap with
    /// the coach mark body).
    public var marginBetweenContentAndPointer: CGFloat = 2.0

    /// Offset between the coach mark and the cutout path.
    public var marginBetweenCoachMarkAndCutoutPath: CGFloat = 2.0

    /// Maximum width for a coach mark.
    public var maxWidth: CGFloat = 350

    /// Trailing and leading margin of the coach mark.
    public var horizontalMargin: CGFloat = 20
}

public struct CoachMarkAnchorConfiguration: Equatable {
    /// The path to cut in the overlay, so the point of interest will be visible.
    public var cutoutPath: UIBezierPath?

    /// The "point of interest" toward which the arrow will point.
    ///
    /// At the moment, it's only used to shift the arrow horizontally and make it sits above/below
    /// the point of interest.
    public var pointOfInterest: CGPoint?

    func computedAnchors() -> CoachMarkAnchorConfiguration {
        CoachMarkAnchorConfiguration(cutoutPath: cutoutPath,
                                     pointOfInterest: computedPointOfInterest())
    }

    /// Compute the orientation of the arrow, given the frame in which the coach mark
    /// will be displayed.
    private func computedPointOfInterest() -> CGPoint {
        // If the value is already set, don't do anything.
        if let pointOfInterest = pointOfInterest { return pointOfInterest }

        // No cutout path means no point of interest.
        // That way, no orientation computation is needed.
        guard let cutoutPath = self.cutoutPath else { return pointOfInterest }

        let xVal = cutoutPath.bounds.origin.x + cutoutPath.bounds.width / 2
        let yVal = cutoutPath.bounds.origin.y + cutoutPath.bounds.height / 2

        return CGPoint(x: xVal, y: yVal)
    }
}

public struct CoachMarkInteractionConfiguration: Equatable {
    /// Set this property to `false` to disable a tap on the overlay.
    /// (only if the tap capture was enabled)
    ///
    /// If you need to disable the tap for all the coach marks, prefer setting
    /// `CoachMarkController.isUserInteractionEnabled` to `false`.
    public var isOverlayInteractionEnabled: Bool = true

    /// Set this property to `true` to allow touch forwarding inside the cutoutPath.
    ///
    /// If you need to enable cutout interaction for all the coachmarks,
    /// prefer setting
    /// `CoachMarkController.isUserInteractionEnabledInsideCutoutPath`
    /// to `true`.
    public var isUserInteractionEnabledInsideCutoutPath: Bool = false
}


extension CoachMarkConfiguration {
    // MARK: - Internal Methods
    /// This method perform both `computeOrientationInFrame` and `computePointOfInterestInFrame`.
    ///
    /// - Parameter frame: the frame in which compute the orientation
    ///                    (likely to match the overlay's frame)
    func computeMetadata(inFrame frame: CGRect) {
        self.computePosition(inFrame: frame)
        self.computePointOfInterest()
    }

    /// Compute the orientation of the arrow, given the frame in which the coach mark
    /// will be displayed.
    ///
    /// - Parameter frame: the frame in which compute the orientation
    ///                    (likely to match the overlay's frame)
    func computePosition(inFrame frame: CGRect) -> ComputedVerticalPosition {
        // No cutout path means no arrow. That way, no orientation
        // computation is needed.
        guard let cutoutPath = cutoutPath else {
            self.position = .automatic
            return
        }

        guard self.position != .automatic else {
            return
        }

        if cutoutPath.bounds.origin.y > frame.size.height / 2 {
            self.position = .above
        } else {
            self.position = .below
        }
    }

    func ceiledMaxWidth(in frame: CGRect) -> CGFloat {
        return min(maxWidth, frame.width - 2 * horizontalMargin)
    }
}
