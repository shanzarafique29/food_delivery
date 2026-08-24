const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// ✅ Jab bhi 'offers' collection mein koi document create/update ho
exports.notifyOnOfferActivated = functions
    .runWith({maxInstances: 10})
    .firestore
    .document("offers/{offerId}")
    .onWrite(async (change) => {
      const before = change.before.exists ? change.before.data() : null;
      const after = change.after.exists ? change.after.data() : null;

      if (!after) return null; // Document delete hua, ignore karo

      const wasActive = before && before.isActive === true;
      const isNowActive = after.isActive === true;

      // ✅ Sirf tab bhejo jab offer NAYI active hui ho
      if (isNowActive && !wasActive) {
        const bodyText = after.requiresCode ?
          `Use code ${after.code} for ${after.discountPercent}% off` :
          `${after.title} — ${after.discountPercent}% off`;

        const payload = {
          notification: {
            title: "New Offer Available!",
            body: bodyText,
          },
          topic: "offers",
        };

        await admin.messaging().send(payload);
      }

      return null;
    });
