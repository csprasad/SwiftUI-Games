//
//
//  GameBG.swift
//  Monorepo
//
/// Created by `C S Prasad` on `07/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Background Decorations
/// Creates a horizontally repeating background decoration from the specified image, offsettable along the x axis.
/// - Parameters:
///   - imageString: The name of the image asset to use for the decoration.
///   - offset: Horizontal offset in points; the offset is wrapped to the view's width so the pattern repeats seamlessly.
/// - Returns: A view that fills the available area with the image tiled and mirrored horizontally, extending into system safe areas.

@ViewBuilder
func decoration(for imageString: String, offset: CGFloat) -> some View {
    GeometryReader { geo in
        let width = geo.size.width
        let normalizedOffset = offset.truncatingRemainder(dividingBy: width)

        ZStack(alignment: .leading) {
            // Normal image
            Image(imageString)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: geo.size.height)
                .offset(x: normalizedOffset)

            // Mirrored image — right edge stitches to right edge of first
            Image(imageString)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: geo.size.height)
                .scaleEffect(x: -1, y: 1)
                .offset(x: normalizedOffset + width)

            // Third image (normal again) to cover the gap after mirrored
//            Image(imageString)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: width, height: geo.size.height)
//                .offset(x: normalizedOffset + width * 2)
        }
    }
    .ignoresSafeArea()
}
