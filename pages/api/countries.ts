// @todo write in ReScript

import type { NextApiRequest, NextApiResponse } from "next";

type ResponseData = {
  message: string;
};

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse<ResponseData>
) {
  const fetchResult = await fetch(
    "https://gist.githubusercontent.com/rusty-key/659db3f4566df459bd59c8a53dc9f71f/raw/4127f9550ef063121c564025f6d27dceeb279623/counties.json",
    {
      headers: {
        "Content-Type": "text/plain",
      },
    }
  );
  const rawData = await fetchResult.text();
  const data = JSON.parse(rawData);

  // inject fake metrics
  const fakeData = data.map((item) => {
    item.metric = (Math.random() * 1000) / 3;
    return item;
  });

  res.status(200).json(fakeData);
}
