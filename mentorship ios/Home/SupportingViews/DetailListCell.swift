//
//  DetailListCell.swift
//  Created on 17/06/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct DetailListCell: View {
    var requestData: HomeModel.HomeResponseData.RequestStructure
    var index: Int
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    var endDate: Date {
        return Date(timeIntervalSince1970: requestData.endDate ?? 0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Form.Spacing.smallSpacing) {
            HStack {
                Text("Mentee: \(requestData.mentee?.userName ?? "-")")
                Spacer()
                Text("Mentor: \(requestData.mentor?.userName ?? "-")")
            }
            .font(.subheadline)
            .foregroundColor(DesignConstants.Colors.defaultIndigoColor)
            
            Text(!requestData.notes!.isEmpty ? requestData.notes! : "notes unavailable")
                .font(.headline)
            
            Text("End Date: \(dateFormatter.string(from: endDate))")
                .font(.caption)
        }
        .padding(.vertical)
    }
}
